@extends('layouts.app')

@section('title', 'Adoption Management')

@section('content')
    <!-- Page Header -->
    <div class="mb-8">
        <div class="flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-semibold text-gray-900">Adoption Management</h1>
                <p class="text-gray-600 mt-1">Review and manage adoption applications</p>
            </div>
        </div>
    </div>

    <!-- Status Tabs -->
    <div class="mb-6">
        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8">
                <a href="#" 
                   class="py-2 px-1 border-b-2 border-gray-900 font-medium text-sm text-gray-900">
                    All Applications
                </a>
                <a href="#" 
                   class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300">
                    Pending
                </a>
                <a href="#" 
                   class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300">
                    Approved
                </a>
                <a href="#" 
                   class="py-2 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300">
                    Rejected
                </a>
            </nav>
        </div>
    </div>

    <!-- Adoption Applications -->
    <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-lg font-semibold text-gray-900">Adoption Applications</h2>
        </div>
        
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Pet
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Applicant
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Date Applied
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Status
                        </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Actions
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse($adoptions as $adoption)
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4">
                                <div class="flex items-center">
                                    <div class="h-10 w-10 flex-shrink-0">
                                        @if($adoption->pet->image)
                                            <img class="h-10 w-10 rounded-lg object-cover" 
                                                 src="{{ asset('storage/pets/' . $adoption->pet->image) }}" 
                                                 alt="{{ $adoption->pet->name }}">
                                        @else
                                            <div class="h-10 w-10 bg-gray-100 rounded-lg flex items-center justify-center">
                                                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                </svg>
                                            </div>
                                        @endif
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900">{{ $adoption->pet->name }}</div>
                                        <div class="text-sm text-gray-500">{{ $adoption->pet->breed }}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="text-sm font-medium text-gray-900">{{ $adoption->user->name }}</div>
                                <div class="text-sm text-gray-500">{{ $adoption->user->email }}</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ $adoption->created_at->format('M d, Y') }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2.5 py-1 text-xs font-medium rounded-full 
                                    {{ $adoption->status === 'pending' ? 'bg-yellow-100 text-yellow-800' : 
                                       ($adoption->status === 'approved' ? 'bg-green-100 text-green-800' : 
                                       'bg-red-100 text-red-800') }}">
                                    {{ ucfirst($adoption->status) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <div class="flex space-x-2">
                                    @if($adoption->status === 'pending')
                                        <form action="{{ route('adoptions.update', $adoption) }}" method="POST">
                                            @csrf
                                            @method('PATCH')
                                            <input type="hidden" name="status" value="approved">
                                            <button type="submit" 
                                                    class="text-green-600 hover:text-green-900 text-sm font-medium">
                                                Approve
                                            </button>
                                        </form>
                                        <span class="text-gray-300">|</span>
                                        <form action="{{ route('adoptions.update', $adoption) }}" method="POST">
                                            @csrf
                                            @method('PATCH')
                                            <input type="hidden" name="status" value="rejected">
                                            <button type="submit" 
                                                    class="text-red-600 hover:text-red-900 text-sm font-medium">
                                                Reject
                                            </button>
                                        </form>
                                    @endif
                                    <span class="text-gray-300">|</span>
                                    <a href="#" class="text-blue-600 hover:text-blue-900">
                                        View
                                    </a>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="px-6 py-12 text-center text-gray-500">
                                <div class="flex flex-col items-center">
                                    <svg class="h-12 w-12 text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                    </svg>
                                    <p class="text-lg">No adoption applications</p>
                                    <p class="text-sm mt-1">When users apply for adoptions, they'll appear here</p>
                                </div>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        @if($adoptions->hasPages())
            <div class="px-6 py-4 border-t border-gray-200">
                {{ $adoptions->links() }}
            </div>
        @endif
    </div>
@endsection