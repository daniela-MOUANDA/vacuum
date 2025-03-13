<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    /**
     * Afficher tous les profils (pour les employeurs).
     */
    public function index()
    {
        // Récupérer tous les profils avec les informations de l'utilisateur associé
        $profiles = Profile::with('user')->get();
        return response()->json($profiles);
    }

    /**
     * Afficher le profil d'un utilisateur.
     */
    public function show($id)
    {
        // Récupérer le profil avec l'utilisateur associé
        $profile = Profile::with('user')->find($id);

        if (!$profile) {
            return response()->json(['message' => 'Profil non trouvé.'], 404);
        }

        return response()->json($profile);
    }

    /**
     * Créer un profil.
     */
    public function store(Request $request)
    {
        // Valider les données de la requête
        $request->validate([
            'skills' => 'required|string', // Compétences (ménage, babysitting, etc.)
            'province' => 'required|string|in:Estuaire,Haut-Ogooué,Moyen-Ogooué,Ngounié,Nyanga,Ogooué-Ivindo,Ogooué-Lolo,Ogooué-Maritime,Woleu-Ntem', // Provinces du Gabon
            'city' => 'required|string', // Ville
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', // Photo de profil (optionnelle)
            'bio' => 'nullable|string', // Bio optionnelle
        ]);

        // Récupérer l'utilisateur authentifié
        $user = Auth::user();

        // Vérifier si l'utilisateur a déjà un profil
        if ($user->profile) {
            return response()->json(['message' => 'Un profil existe déjà pour cet utilisateur.'], 400);
        }

        // Gérer l'upload de la photo de profil
        $profilePicturePath = null;
        if ($request->hasFile('profile_picture')) {
            $profilePicturePath = $request->file('profile_picture')->store('profile_pictures', 'public');
        }

        // Créer le profil
        $profile = Profile::create([
            'user_id' => $user->id,
            'skills' => $request->skills,
            'province' => $request->province,
            'city' => $request->city,
            'profile_picture' => $profilePicturePath,
            'bio' => $request->bio,
        ]);

        return response()->json($profile, 201);
    }

    /**
     * Mettre à jour un profil.
     */
    public function update(Request $request, $id)
    {
        // Valider les données de la requête
        $request->validate([
            'skills' => 'sometimes|string', // Compétences (optionnelles pour la mise à jour)
            'province' => 'sometimes|string|in:Estuaire,Haut-Ogooué,Moyen-Ogooué,Ngounié,Nyanga,Ogooué-Ivindo,Ogooué-Lolo,Ogooué-Maritime,Woleu-Ntem', // Provinces du Gabon
            'city' => 'sometimes|string', // Ville
            'profile_picture' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', // Photo de profil (optionnelle)
            'bio' => 'nullable|string', // Bio optionnelle
        ]);

        // Récupérer le profil à mettre à jour
        $profile = Profile::find($id);

        if (!$profile) {
            return response()->json(['message' => 'Profil non trouvé.'], 404);
        }

        // Vérifier que l'utilisateur authentifié est bien le propriétaire du profil
        if ($profile->user_id !== Auth::id()) {
            return response()->json(['message' => 'Non autorisé.'], 403);
        }

        // Gérer l'upload de la photo de profil
        if ($request->hasFile('profile_picture')) {
            // Supprimer l'ancienne photo de profil si elle existe
            if ($profile->profile_picture) {
                Storage::disk('public')->delete($profile->profile_picture);
            }
            // Stocker la nouvelle photo de profil
            $profilePicturePath = $request->file('profile_picture')->store('profile_pictures', 'public');
            $profile->profile_picture = $profilePicturePath;
        }

        // Mettre à jour le profil
        $profile->update($request->only(['skills', 'province', 'city', 'bio']));

        return response()->json($profile);
    }

    /**
     * Supprimer un profil.
     */
    public function destroy($id)
    {
        // Récupérer le profil à supprimer
        $profile = Profile::find($id);

        if (!$profile) {
            return response()->json(['message' => 'Profil non trouvé.'], 404);
        }

        // Vérifier que l'utilisateur authentifié est bien le propriétaire du profil
        if ($profile->user_id !== Auth::id()) {
            return response()->json(['message' => 'Non autorisé.'], 403);
        }

        // Supprimer la photo de profil si elle existe
        if ($profile->profile_picture) {
            Storage::disk('public')->delete($profile->profile_picture);
        }

        // Supprimer le profil
        $profile->delete();

        return response()->json(['message' => 'Profil supprimé avec succès.'], 204);
    }
}