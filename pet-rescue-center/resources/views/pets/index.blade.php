@extends('layouts.app')

@section('title', 'Pets Management')

@section('content')
    <!-- Page Header -->
    <div class="mb-8">
        <div class="flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-semibold text-gray-900">Pets Management</h1>
                <p class="text-gray-600 mt-1">Manage all rescue pets in the system</p>
            </div>
            <a href="{{ route('pets.create') }}" 
               class="px-5 py-2.5 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors font-medium">
                Add New Pet
            </a>
        </div>
    </div>

    <!-- Stats Summary -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div class="bg-white p-4 rounded-lg border border-gray-200">
            <div class="text-sm text-gray-600">Total Pets</div>
            <div class="text-xl font-semibold mt-1">{{ \App\Models\Pet::count() }}</div>
        </div>
        <div class="bg-white p-4 rounded-lg border border-gray-200">
            <div class="text-sm text-gray-600">Available</div>
            <div class="text-xl font-semibold mt-1">{{ \App\Models\Pet::where('status', 'Available')->count() }}</div>
        </div>
        <div class="bg-white p-4 rounded-lg border border-gray-200">
            <div class="text-sm text-gray-600">Adopted</div>
            <div class="text-xl font-semibold mt-1">{{ \App\Models\Pet::where('status', 'Adopted')->count() }}</div>
        </div>
        <div class="bg-white p-4 rounded-lg border border-gray-200">
            <div class="text-sm text-gray-600">Pending</div>
            <div class="text-xl font-semibold mt-1">{{ \App\Models\Pet::where('status', 'Pending')->count() }}</div>
        </div>
    </div>

    <!-- Pets Table -->
    <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-lg font-semibold text-gray-900">All Pets</h2>
        </div>
        
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Pet
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Type
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Age
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Status
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Location
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Actions
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse($pets as $pet)
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="h-10 w-10 flex-shrink-0">
                                        @if($pet->image)
                                            <img class="h-10 w-10 rounded-lg object-cover" 
                                                 src="{{ asset('storage/pets/' . $pet->image) }}" 
                                                 alt="{{ $pet->name }}">
                                        @else
                                            <div class="h-10 w-10 bg-gray-100 rounded-lg flex items-center justify-center">
                                                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                </svg>
                                            </div>
                                        @endif
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900">{{ $pet->name }}</div>
                                        <div class="text-sm text-gray-500">{{ $pet->breed }}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900">{{ $pet->type }}</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900">{{ $pet->age }} years</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2.5 py-1 text-xs font-medium rounded-full {{ $pet->status === 'Available' ? 'bg-green-100 text-green-800' : ($pet->status === 'Adopted' ? 'bg-purple-100 text-purple-800' : 'bg-orange-100 text-orange-800') }}">
                                    {{ $pet->status }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ $pet->location }}
                            </td>
                           <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
    <a href="{{ route('pets.show', $pet->id) }}" class="text-blue-600 hover:text-blue-900 mr-3">
        View
    </a>
    <a href="{{ route('pets.edit', $pet->id) }}" class="text-gray-600 hover:text-gray-900 mr-3">
        Edit
    </a>
    <form action="{{ route('pets.destroy', $pet->id) }}" method="POST" class="inline">
        @csrf
        @method('DELETE')
        <button type="submit" 
                onclick="return confirm('Are you sure you want to delete {{ $pet->name }}?')"
                class="text-red-600 hover:text-red-900">
            Delete
        </button>
    </form>
</td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                <div class="flex flex-col items-center">
                                    <svg class="h-12 w-12 text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <p class="text-lg">No pets found</p>
                                    <p class="text-sm mt-1">Add your first rescue pet to get started</p>
                                </div>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        @if($pets->hasPages())
            <div class="px-6 py-4 border-t border-gray-200">
                {{ $pets->links() }}
            </div>
        @endif
    </div>
@endsection