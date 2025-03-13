<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->enum('type', ['particular', 'company'])->nullable(); // Type d'employeur
            $table->string('company_name')->nullable(); // Nom de l'entreprise (uniquement pour les entreprises)
        });
    }
    
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('type');
            $table->dropColumn('company_name');
        });
    }
};
