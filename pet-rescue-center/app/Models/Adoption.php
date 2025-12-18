<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Adoption extends Model
{
     protected $fillable = [
        'pet_id', 'user_id', 'status', 'notes'
    ];

     protected $attributes = [
        'status' => 'pending'
    ];

    // Pet relationship
    public function pet()
    {
        return $this->belongsTo(Pet::class);
    }

    // User relationship
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
