@extends('layouts.app')

@section('title', $pet->name . ' - Details')

@section('content')
    <!-- Page Header -->
    <div class="mb-8">
        <div class="flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-semibold text-gray-900">{{ $pet->name }}</h1>
                <p class="text-gray-600 mt-1">Pet details and information</p>
            </div>
            <a href="{{ route('pets.index') }}" 
               class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium">
                Back to Pets
            </a>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left Column - Image & Basic Info -->
        <div class="lg:col-span-1">
            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <!-- Pet Image -->
                <div class="mb-6">
                    <div class="relative">
                        @if($pet->image)
                            <img src="{{ asset('storage/pets/' . $pet->image) }}" 
                                 alt="{{ $pet->name }}" 
                                 class="w-full h-64 object-cover rounded-lg">
                        @else
                            <div class="w-full h-64 bg-gray-100 rounded-lg flex items-center justify-center">
                                <svg class="h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                </svg>
                            </div>
                        @endif
                        
                        <!-- Status Badge -->
                        <div class="absolute top-4 right-4">
                            <span class="px-3 py-1 rounded-full text-xs font-medium {{ $pet->status === 'Available' ? 'bg-green-100 text-green-800' : ($pet->status === 'Adopted' ? 'bg-purple-100 text-purple-800' : 'bg-orange-100 text-orange-800') }}">
                                {{ $pet->status }}
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Basic Information -->
                <div class="space-y-4">
                    <h3 class="text-lg font-medium text-gray-900">Basic Information</h3>
                    
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-gray-500">Type</p>
                            <p class="font-medium">{{ $pet->type }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Breed</p>
                            <p class="font-medium">{{ $pet->breed ?? 'N/A' }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Age</p>
                            <p class="font-medium">{{ $pet->age }} years</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Gender</p>
                            <p class="font-medium">{{ $pet->gender ?? 'N/A' }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Size</p>
                            <p class="font-medium">{{ $pet->size ?? 'N/A' }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Location</p>
                            <p class="font-medium">{{ $pet->location }}</p>
                        </div>
                    </div>
                    
                    <!-- Timeline -->
                    <div class="pt-4 border-t border-gray-200">
                        <h4 class="text-sm font-medium text-gray-900 mb-3">Timeline</h4>
                        <div class="space-y-3">
                            <div>
                                <p class="text-xs text-gray-500">Registered</p>
                                <p class="text-sm">{{ $pet->created_at->format('M d, Y') }}</p>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500">Last Updated</p>
                                <p class="text-sm">{{ $pet->updated_at->format('M d, Y') }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Actions Card -->
            <div class="bg-white rounded-lg border border-gray-200 p-6 mt-6">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Actions</h3>
                <div class="space-y-3">
                    <a href="{{ route('pets.edit', $pet->id) }}" 
                       class="w-full flex items-center justify-center px-4 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                        </svg>
                        Edit Pet
                    </a>
                    
                    <form action="{{ route('pets.destroy', $pet->id) }}" method="POST" class="w-full">
                        @csrf
                        @method('DELETE')
                        <button type="submit" 
                                onclick="return confirm('Are you sure you want to delete {{ $pet->name }}?')"
                                class="w-full flex items-center justify-center px-4 py-2.5 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                            Delete Pet
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Right Column - Description & Adoptions -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Description Card -->
            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Description</h3>
                @if($pet->description)
                    <p class="text-gray-700 whitespace-pre-line">{{ $pet->description }}</p>
                @else
                    <p class="text-gray-500 italic">No description provided for this pet.</p>
                @endif
            </div>

            <!-- Adoption History -->
            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-medium text-gray-900">Adoption History</h3>
                    @if($pet->status === 'Available')
                        <button class="px-4 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors text-sm font-medium">
                            Mark as Adopted
                        </button>
                    @endif
                </div>
                
                <div class="space-y-4">
                    @forelse($pet->adoptions as $adoption)
                        <div class="border border-gray-200 rounded-lg p-4">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="font-medium text-gray-900">{{ $adoption->user->name }}</p>
                                    <p class="text-sm text-gray-500">{{ $adoption->user->email }}</p>
                                </div>
                                <span class="px-2.5 py-1 text-xs font-medium rounded-full 
                                    {{ $adoption->status === 'pending' ? 'bg-yellow-100 text-yellow-800' : 
                                       ($adoption->status === 'approved' ? 'bg-green-100 text-green-800' : 
                                       'bg-red-100 text-red-800') }}">
                                    {{ ucfirst($adoption->status) }}
                                </span>
                            </div>
                            
                            <div class="mt-3 text-sm text-gray-600">
                                <p><strong>Applied:</strong> {{ $adoption->created_at->format('M d, Y') }}</p>
                                @if($adoption->notes)
                                    <p class="mt-2"><strong>Notes:</strong> {{ $adoption->notes }}</p>
                                @endif
                            </div>
                        </div>
                    @empty
                        <div class="text-center py-8 text-gray-500">
                            <svg class="h-12 w-12 mx-auto text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                            <p>No adoption history for this pet.</p>
                        </div>
                    @endforelse
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-white rounded-lg border border-gray-200 p-4">
                    <p class="text-sm text-gray-500">Days in Shelter</p>
                    <p class="text-xl font-semibold mt-1">
                        {{ \Carbon\Carbon::parse($pet->created_at)->diffInDays() }} days
                    </p>
                </div>
                <div class="bg-white rounded-lg border border-gray-200 p-4">
                    <p class="text-sm text-gray-500">Adoption Applications</p>
                    <p class="text-xl font-semibold mt-1">{{ $pet->adoptions->count() }}</p>
                </div>
            </div>
        </div>
    </div>
@endsection