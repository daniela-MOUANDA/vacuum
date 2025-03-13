<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Profile extends Model
{
    use HasFactory;

    /**
     * Les attributs assignables en masse.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',       // ID de l'utilisateur associé
        'skills',        // Compétences (ménage, babysitting, etc.)
        'province',      // Province (parmi les 9 du Gabon)
        'city',          // Ville
        'profile_picture', // Photo de profil (optionnelle)
        'bio',           // Bio optionnelle
    ];

    /**
     * Relation avec le modèle User.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}