@extends('layouts.app')
@section('content')

@section('title', 'Dashboard')

    <!-- Welcome Banner -->
    <div class="bg-gradient-to-r from-gray-800 to-gray-900 rounded-lg shadow-sm p-8 mb-8 text-white">
        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
            <div>
                <h1 class="text-3xl font-semibold mb-2">Welcome back, {{ Auth::user()->name }}</h1>
                <p class="text-gray-300">Manage your pet rescue center efficiently</p>
            </div>
            <a href="{{ route('pets.create') }}" 
               class="px-6 py-3 bg-white text-gray-900 rounded-lg font-medium hover:bg-gray-100 transition-colors">
                Add New Pet
            </a>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Pets -->
        <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2 1 3 3 3h10c2 0 3-1 3-3V7c0-2-1-3-3-3H7c-2 0-3 1-3 3z"/>
                    </svg>
                </div>
            </div>
            <p class="text-sm font-medium text-gray-600 mb-1">Total Pets</p>
            <p class="text-2xl font-semibold text-gray-900">{{ \App\Models\Pet::count() }}</p>
            <div class="mt-3 flex items-center text-sm text-gray-500">
                <span>All registered pets</span>
            </div>
        </div>

        <!-- Available -->
        <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-green-50 rounded-lg flex items-center justify-center">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                </div>
            </div>
            <p class="text-sm font-medium text-gray-600 mb-1">Available</p>
            <p class="text-2xl font-semibold text-gray-900">{{ \App\Models\Pet::where('status', 'Available')->count() }}</p>
            <div class="mt-3 flex items-center text-sm text-gray-500">
                <span>Ready for adoption</span>
            </div>
        </div>

        <!-- Adopted -->
        <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-purple-50 rounded-lg flex items-center justify-center">
                    <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                    </svg>
                </div>
            </div>
            <p class="text-sm font-medium text-gray-600 mb-1">Adopted</p>
            <p class="text-2xl font-semibold text-gray-900">{{ \App\Models\Pet::where('status', 'Adopted')->count() }}</p>
            <div class="mt-3 flex items-center text-sm text-gray-500">
                <span>Successfully adopted</span>
            </div>
        </div>

        <!-- Pending Adoptions -->
        <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-orange-50 rounded-lg flex items-center justify-center">
                    <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
            </div>
            <p class="text-sm font-medium text-gray-600 mb-1">Pending</p>
            <p class="text-2xl font-semibold text-gray-900">{{ \App\Models\Adoption::where('status', 'pending')->count() }}</p>
            <div class="mt-3 flex items-center text-sm text-gray-500">
                <span>Awaiting review</span>
            </div>
        </div>
    </div>

    <!-- Recent Activity & Quick Actions -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Recent Pets -->
        <div class="lg:col-span-2 bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-semibold text-gray-900">Recent Pets</h2>
                <a href="{{ route('pets.index') }}" class="text-gray-600 hover:text-gray-900 font-medium text-sm">
                    View All
                </a>
            </div>
            
            <div class="space-y-3">
                @forelse(\App\Models\Pet::latest()->take(5)->get() as $pet)
                    <div class="flex items-center gap-4 p-4 rounded-lg hover:bg-gray-50 transition-colors border border-gray-100">
                        <div class="w-14 h-14 bg-gray-100 rounded-lg flex items-center justify-center shrink-0 overflow-hidden">
                            @if($pet->image)
                                <img src="{{ asset('storage/pets/' . $pet->image) }}" alt="{{ $pet->name }}" class="w-full h-full object-cover">
                            @else
                                <svg class="w-7 h-7 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                </svg>
                            @endif
                        </div>
                        <div class="flex-1">
                            <h3 class="font-medium text-gray-900">{{ $pet->name }}</h3>
                            <p class="text-sm text-gray-500">{{ $pet->breed }} • {{ $pet->age }} years old</p>
                        </div>
                        <span class="px-3 py-1 rounded-full text-xs font-medium {{ $pet->status === 'Available' ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-purple-50 text-purple-700 border border-purple-200' }}">
                            {{ $pet->status }}
                        </span>
                    </div>
                @empty
                    <p class="text-center text-gray-500 py-8">No pets registered yet</p>
                @endforelse
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
            <h2 class="text-xl font-semibold text-gray-900 mb-6">Quick Actions</h2>
            
            <div class="space-y-3">
                <a href="{{ route('pets.create') }}" 
                   class="flex items-center gap-3 p-4 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors border border-gray-200">
                    <div class="w-10 h-10 bg-gray-900 rounded-lg flex items-center justify-center shrink-0">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                    </div>
                    <div>
                        <div class="font-medium text-gray-900">Add Pet</div>
                        <div class="text-xs text-gray-500">Register new rescue</div>
                    </div>
                </a>

                <a href="{{ route('pets.adoptions') }}" 
                   class="flex items-center gap-3 p-4 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors border border-gray-200">
                    <div class="w-10 h-10 bg-gray-900 rounded-lg flex items-center justify-center shrink-0">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                    </div>
                    <div>
                        <div class="font-medium text-gray-900">Adoptions</div>
                        <div class="text-xs text-gray-500">Review applications</div>
                    </div>
                </a>

                <a href="{{ route('pets.index') }}" 
                   class="flex items-center gap-3 p-4 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors border border-gray-200">
                    <div class="w-10 h-10 bg-gray-900 rounded-lg flex items-center justify-center shrink-0">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </div>
                    <div>
                        <div class="font-medium text-gray-900">View All Pets</div>
                        <div class="text-xs text-gray-500">Browse database</div>
                    </div>
                </a>
            </div>
        </div>
    </div>
@endsection