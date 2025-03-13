<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProfileController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    // Afficher le profil d'un utilisateur
    Route::get('/profile/{id}', [ProfileController::class, 'show']);

    // Créer ou mettre à jour un profil
    Route::post('/profile', [ProfileController::class, 'store']);
    Route::put('/profile/{id}', [ProfileController::class, 'update']);

    // Supprimer un profil
    Route::delete('/profile/{id}', [ProfileController::class, 'destroy']);
});