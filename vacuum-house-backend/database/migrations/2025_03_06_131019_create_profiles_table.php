<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProfilesTable extends Migration
{
    /**
     * Exécute la migration.
     */
    public function up()
    {
        Schema::create('profiles', function (Blueprint $table) {
            $table->id(); // ID du profil
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Clé étrangère vers la table `users`
            $table->string('skills'); // Compétences (ménage, babysitting, etc.)
            $table->enum('province', [
                'Estuaire', 'Haut-Ogooué', 'Moyen-Ogooué', 'Ngounié', 'Nyanga', 
                'Ogooué-Ivindo', 'Ogooué-Lolo', 'Ogooué-Maritime', 'Woleu-Ntem'
            ]); // Province (parmi les 9 du Gabon)
            $table->string('city'); // Ville
            $table->string('profile_picture')->nullable(); // Photo de profil (optionnelle)
            $table->text('bio')->nullable(); // Bio optionnelle
            $table->timestamps(); // Timestamps (created_at et updated_at)
        });
    }

    /**
     * Annule la migration.
     */
    public function down()
    {
        Schema::dropIfExists('profiles');
    }
}