<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PetController;


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
   

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::post('/change-password', [AuthController::class, 'changePassword']);
    Route::get('/check-token', [AuthController::class, 'checkToken']);


    Route::get('/pets', [PetController::class, 'index']);
    Route::get('/pets/{id}', [PetController::class, 'show']);
    Route::get('/pets/search', [PetController::class, 'search']); 
    Route::post('/pets/{id}/adopt', [PetController::class, 'adopt']);
    Route::post('/pets/{id}/cancel-adoption', [PetController::class, 'cancelAdoption']);
    Route::get('/pets/adoptions/my', [PetController::class, 'myAdoptions']); 
});