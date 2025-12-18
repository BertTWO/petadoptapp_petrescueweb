<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

use Illuminate\Database\Eloquent\Relations\HasMany;
class Pet extends Model
{
    /** @use HasFactory<\Database\Factories\PetFactory> */
    use HasFactory;

    protected $fillable = [
        'name', 'type', 'breed', 'age', 'image', 'description', 
        'status', 'location'
    ];
public function adoptions(): HasMany
    {
        return $this->hasMany(Adoption::class);
    }
    public function getImageUrlAttribute()
    {
        return url('storage/pets/' . $this->image);
    }
     public function scopeAvailable($query)
    {
        return $query->where('status', 'available');
    }
}
