<?php

namespace App\Http\Controllers\Api;

use App\Models\Pet;
use App\Models\Adoption;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PetController
{

    public function index()
    {
        $pets = Pet::where('status', 'available')
                   ->with('adoptions') // If you have relationship
                   ->get()
                   ->map(function ($pet) {
                       // Ensure image URL is included
                       $pet->image_url = $pet->image ? url('storage/pets/' . $pet->image) : null;
                       return $pet;
                   });

        return response()->json([
            'success' => true,
            'data' => $pets,
            'count' => $pets->count()
        ]);
    }

    /**
     * Get single pet details for API
     */
    public function show($id)
    {
        $pet = Pet::with('adoptions')->findOrFail($id);
        
        // Add full image URL
        $pet->image_url = $pet->image ? url('storage/pets/' . $pet->image) : null;

        return response()->json([
            'success' => true,
            'data' => $pet
        ]);
    }

    /**
     * Adopt a pet (API endpoint for Flutter)
     */
    public function adopt(Request $request, $id)
    {
        $request->validate([
            'notes' => 'nullable|string|max:500'
        ]);

        $pet = Pet::findOrFail($id);
        
        // Check if pet is available
        if ($pet->status !== 'available') {
            return response()->json([
                'success' => false,
                'message' => 'This pet is not available for adoption'
            ], 400);
        }

        // Check if user already has pending adoption for this pet
        $existingAdoption = Adoption::where('pet_id', $pet->id)
            ->where('user_id', $request->user()->id)
            ->where('status', 'pending')
            ->exists();

        if ($existingAdoption) {
            return response()->json([
                'success' => false,
                'message' => 'You already have a pending adoption request for this pet'
            ], 400);
        }

        // Create adoption record
        $adoption = Adoption::create([
            'pet_id' => $pet->id,
            'user_id' => $request->user()->id,
            'status' => 'pending',
            'notes' => $request->notes,
            'adoption_date' => now(),
        ]);

        // Update pet status
        $pet->update(['status' => 'Pending']);

        return response()->json([
            'success' => true,
            'message' => 'Adoption request submitted successfully',
            'data' => $adoption
        ], 201);
    }

    /**
     * Cancel adoption (API endpoint for Flutter)
     */
    public function cancelAdoption(Request $request, $id)
    {
        $pet = Pet::findOrFail($id);
        
        // Find the pending adoption
        $adoption = Adoption::where('pet_id', $pet->id)
            ->where('user_id', $request->user()->id)
            ->where('status', 'pending')
            ->first();

        if (!$adoption) {
            return response()->json([
                'success' => false,
                'message' => 'No pending adoption found for this pet'
            ], 404);
        }

        // Update adoption status
        $adoption->update(['status' => 'cancelled']);
        
        // Make pet available again
        $pet->update(['status' => 'available']);

        return response()->json([
            'success' => true,
            'message' => 'Adoption request cancelled successfully'
        ]);
    }

    /**
     * Get user's adoption history (API)
     */
    public function myAdoptions(Request $request)
    {
        $adoptions = Adoption::with('pet')
            ->where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($adoption) {
                if ($adoption->pet) {
                    $adoption->pet->image_url = $adoption->pet->image 
                        ? url('storage/pets/' . $adoption->pet->image) 
                        : null;
                }
                return $adoption;
            });

        return response()->json([
            'success' => true,
            'data' => $adoptions
        ]);
    }

    /**
     * Search/filter pets (API)
     */
    public function search(Request $request)
    {
        $query = Pet::where('status', 'available');

        // Filter by type
        if ($request->has('type') && $request->type !== 'all') {
            $query->where('type', $request->type);
        }

        // Filter by location
        if ($request->has('location')) {
            $query->where('location', 'like', '%' . $request->location . '%');
        }

        $pets = $query->get()
            ->map(function ($pet) {
                $pet->image_url = $pet->image ? url('storage/pets/' . $pet->image) : null;
                return $pet;
            });

        return response()->json([
            'success' => true,
            'data' => $pets,
            'filters' => $request->only(['type', 'location'])
        ]);
    }
}