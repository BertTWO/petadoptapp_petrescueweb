<?php

namespace App\Http\Controllers;

use App\Models\Pet;
use App\Models\Adoption;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
class PetController
{
    /**
     * Display pets for admin/web dashboard
     */
    public function index()
    {
        $pets = Pet::with('adoptions')->paginate(20);
        return view('pets.index', compact('pets'));
    }

    /**
     * Show form to create new pet (web)
     */
    public function create()
    {
        return view('pets.create');
    }

    /**
     * Store new pet (web)
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string',
            'breed' => 'nullable|string',
            'age' => 'required|integer',
            'image' => 'nullable|image|max:2048',
            'description' => 'nullable|string',
            'location' => 'required|string',
        ]);

        $data = $request->all();
        
        // Handle image upload
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('pets', 'public');
            $data['image'] = basename($imagePath);
        }

        Pet::create($data);

        return redirect()->route('pets.index')
            ->with('success', 'Pet added successfully');
    }

    /**
     * Show pet details (web)
     */
    public function show(Pet $pet)
    {
        return view('pets.show', compact('pet'));
    }

    /**
     * Manage adoptions (web admin)
     */
   public function manageAdoptions()
{
    $adoptions = Adoption::with(['pet', 'user'])
        ->orderBy('created_at', 'desc')
        ->paginate(10); // Add pagination
    return view('pets.adoptions', compact('adoptions'));
}

    /**
     * Update adoption status (web admin)
     */
    public function updateAdoptionStatus(Request $request, Adoption $adoption)
    {
        $request->validate([
            'status' => 'required|in:approved,rejected,completed,cancelled'
        ]);

        $adoption->update(['status' => $request->status]);
        
        // Update pet status if adoption is approved/completed
        if (in_array($request->status, ['approved', 'completed'])) {
            $adoption->pet->update(['status' => 'Adopted']);
        } elseif ($request->status === 'cancelled') {
            $adoption->pet->update(['status' => 'Available']);
        }

        return back()->with('success', 'Adoption status updated');
    }
      public function edit(Pet $pet)
    {
        return view('pets.edit', compact('pet'));
    }

    /**
     * Update pet information
     */
    public function update(Request $request, Pet $pet)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string',
            'breed' => 'nullable|string',
            'age' => 'required|integer',
            'image' => 'nullable|image|max:2048',
            'description' => 'nullable|string',
            'location' => 'required|string',
        ]);

        $data = $request->all();
        
        // Handle image upload
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($pet->image) {
                Storage::disk('public')->delete('pets/' . $pet->image);
            }
            
            $imagePath = $request->file('image')->store('pets', 'public');
            $data['image'] = basename($imagePath);
        }

        $pet->update($data);

        return redirect()->route('pets.index')
            ->with('success', 'Pet updated successfully');
    }

    /**
     * Delete pet
     */
    public function destroy(Pet $pet)
    {
        // Delete pet image if exists
        if ($pet->image) {
            Storage::disk('public')->delete('pets/' . $pet->image);
        }
        
        $pet->delete();

        return redirect()->route('pets.index')
            ->with('success', 'Pet deleted successfully');
    }
}