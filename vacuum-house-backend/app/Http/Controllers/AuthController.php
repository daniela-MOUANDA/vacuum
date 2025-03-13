<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        // Valider les données
        $request->validate([
            'role' => 'required|in:employee,employer', // Rôle de l'utilisateur
            'name' => 'nullable|required_if:role,employee,particular|string|max:255', // Nom (pour employés et particuliers)
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
            'telephone' => 'required|string|max:20',
            'type' => 'nullable|required_if:role,employer|in:particular,company', // Type d'employeur
            'company_name' => 'nullable|required_if:type,company|string|max:255', // Nom de l'entreprise (uniquement pour les entreprises)
        ]);
    
        // Définir le nom en fonction du type d'utilisateur
        $name = $request->role === 'employee' || $request->type === 'particular'
            ? $request->name
            : $request->company_name;
    
        // Créer l'utilisateur
        $user = User::create([
            'name' => $name, // Utiliser le nom de l'entreprise si c'est une entreprise
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role,
            'telephone' => $request->telephone,
            'type' => $request->role === 'employer' ? $request->type : null, // Type d'employeur
            'company_name' => $request->type === 'company' ? $request->company_name : null, // Nom de l'entreprise
        ]);
    
        return response()->json([
            'message' => 'Inscription réussie.',
            'user' => $user,
        ], 201);
    }

    public function login(Request $request)
{
    // Valider les données
    $credentials = $request->validate([
        'email' => 'required|string|email',
        'password' => 'required|string',
    ]);

    // Vérifier si l'utilisateur existe
    $user = User::where('email', $credentials['email'])->first();

    // Vérifier le mot de passe et si l'utilisateur existe
    if (!$user || !Hash::check($credentials['password'], $user->password)) {
        return response()->json(['message' => 'Identifiants incorrects.'], 401);
    }

    // Générer un token pour l'utilisateur
    $token = $user->createToken('auth_token')->plainTextToken;

    // Informations spécifiques en fonction du rôle et du type
    $userData = [
        'id' => $user->id,
        'name' => $user->name,
        'email' => $user->email,
        'role' => $user->role,
        'telephone' => $user->telephone,
    ];

    if ($user->role === 'employer') {
        $userData['type'] = $user->type;
        if ($user->type === 'company') {
            $userData['company_name'] = $user->company_name;
        }
    }

    // Retourner les informations de l'utilisateur et le token
    return response()->json([
        'message' => 'Connexion réussie.',
        'user' => $userData,
        'token' => $token,
    ]);
}
}
