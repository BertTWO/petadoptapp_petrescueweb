@extends('layouts.app')

@section('title', 'Edit Pet')

@section('content')
    <!-- Page Header -->
    <div class="mb-8">
        <div class="flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-semibold text-gray-900">Edit Pet</h1>
                <p class="text-gray-600 mt-1">Update information for {{ $pet->name }}</p>
            </div>
            <a href="{{ route('pets.index') }}" 
               class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium">
                Back to Pets
            </a>
        </div>
    </div>

    <div class="bg-white rounded-lg border border-gray-200 p-6">
        @if($errors->any())
            <div class="mb-6 bg-red-50 border border-red-200 text-red-800 px-5 py-4 rounded-lg">
                <div class="flex items-center">
                    <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                    </svg>
                    <div>
                        <p class="font-medium">Please fix the following errors:</p>
                        <ul class="list-disc list-inside mt-1 text-sm">
                            @foreach($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                </div>
            </div>
        @endif

        <form action="{{ route('pets.update', $pet->id) }}" method="POST" enctype="multipart/form-data" id="petForm">
            @csrf
            @method('PUT')
            
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Left Column - Image Preview -->
                <div class="lg:col-span-1">
                    <div class="sticky top-6">
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Pet Image</label>
                            <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-gray-400 transition-colors" 
                                 id="imageDropzone">
                                <div class="space-y-1 text-center">
                                    <!-- Current Image Preview -->
                                    <div class="mb-4">
                                        @if($pet->image)
                                            <img id="currentImage" 
                                                 src="{{ asset('storage/pets/' . $pet->image) }}" 
                                                 class="mx-auto h-48 w-48 object-cover rounded-lg"
                                                 alt="{{ $pet->name }}">
                                        @else
                                            <img id="currentImage" 
                                                 src="" 
                                                 class="mx-auto h-48 w-48 object-cover rounded-lg hidden"
                                                 alt="">
                                            <div id="placeholderIcon" class="mx-auto h-48 w-48 flex items-center justify-center bg-gray-100 rounded-lg">
                                                <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                                                    <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                                </svg>
                                            </div>
                                        @endif
                                        
                                        <!-- New Image Preview -->
                                        <img id="imagePreview" 
                                             class="mx-auto h-48 w-48 object-cover rounded-lg hidden mt-4"
                                             alt="New image preview">
                                    </div>
                                    
                                    <!-- Upload Button -->
                                    <div class="flex text-sm text-gray-600">
                                        <label for="image" class="relative cursor-pointer bg-gray-900 text-white rounded-md px-4 py-2 font-medium hover:bg-gray-800 transition-colors">
                                            <span>Change Image</span>
                                            <input id="image" name="image" type="file" accept="image/*" class="sr-only" onchange="previewImage(event)">
                                        </label>
                                    </div>
                                    
                                    <p class="text-xs text-gray-500 mt-2">
                                        PNG, JPG, GIF up to 2MB
                                    </p>
                                    <p class="text-xs text-gray-500" id="fileName"></p>
                                    
                                    <!-- Remove New Image Button -->
                                    <button type="button" id="removeImageBtn" 
                                            class="mt-2 text-sm text-red-600 hover:text-red-800 hidden"
                                            onclick="removeImage()">
                                        Remove New Image
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Current Info -->
                        <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-800 mb-2">Current Information</h4>
                            <ul class="text-xs text-gray-600 space-y-1">
                                <li><strong>Status:</strong> {{ $pet->status }}</li>
                                <li><strong>Created:</strong> {{ $pet->created_at->format('M d, Y') }}</li>
                                <li><strong>Last Updated:</strong> {{ $pet->updated_at->format('M d, Y') }}</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Form Fields -->
                <div class="lg:col-span-2">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Pet Name *</label>
                            <input type="text" name="name" required 
                                   value="{{ old('name', $pet->name) }}"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Type *</label>
                            <select name="type" required 
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                                <option value="">Select Type</option>
                                <option value="Dog" {{ old('type', $pet->type) == 'Dog' ? 'selected' : '' }}>Dog</option>
                                <option value="Cat" {{ old('type', $pet->type) == 'Cat' ? 'selected' : '' }}>Cat</option>
                                <option value="Bird" {{ old('type', $pet->type) == 'Bird' ? 'selected' : '' }}>Bird</option>
                                <option value="Rabbit" {{ old('type', $pet->type) == 'Rabbit' ? 'selected' : '' }}>Rabbit</option>
                                <option value="Other" {{ old('type', $pet->type) == 'Other' ? 'selected' : '' }}>Other</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Breed</label>
                            <input type="text" name="breed" 
                                   value="{{ old('breed', $pet->breed) }}"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors"
                                   placeholder="e.g., Golden Retriever">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Age (years) *</label>
                            <input type="number" name="age" min="0" max="30" required 
                                   value="{{ old('age', $pet->age) }}"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Gender</label>
                            <select name="gender" 
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                                <option value="">Select Gender</option>
                                <option value="Male" {{ old('gender', $pet->gender) == 'Male' ? 'selected' : '' }}>Male</option>
                                <option value="Female" {{ old('gender', $pet->gender) == 'Female' ? 'selected' : '' }}>Female</option>
                                <option value="Unknown" {{ old('gender', $pet->gender) == 'Unknown' ? 'selected' : '' }}>Unknown</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Size</label>
                            <select name="size" 
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                                <option value="">Select Size</option>
                                <option value="Small" {{ old('size', $pet->size) == 'Small' ? 'selected' : '' }}>Small</option>
                                <option value="Medium" {{ old('size', $pet->size) == 'Medium' ? 'selected' : '' }}>Medium</option>
                                <option value="Large" {{ old('size', $pet->size) == 'Large' ? 'selected' : '' }}>Large</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Status *</label>
                            <select name="status" required 
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors">
                                <option value="Available" {{ old('status', $pet->status) == 'Available' ? 'selected' : '' }}>Available</option>
                                <option value="Pending" {{ old('status', $pet->status) == 'Pending' ? 'selected' : '' }}>Pending</option>
                                <option value="Adopted" {{ old('status', $pet->status) == 'Adopted' ? 'selected' : '' }}>Adopted</option>
                                <option value="Reserved" {{ old('status', $pet->status) == 'Reserved' ? 'selected' : '' }}>Reserved</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Location *</label>
                            <input type="text" name="location" required 
                                   value="{{ old('location', $pet->location) }}"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors"
                                   placeholder="e.g., Bay ni Fill Edward Shelter">
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="mt-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                        <textarea name="description" rows="4" 
                                  class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-900 focus:border-gray-900 transition-colors"
                                  placeholder="Tell us about this pet's personality, history, special needs, etc.">{{ old('description', $pet->description) }}</textarea>
                    </div>

                    <!-- Form Actions -->
                    <div class="mt-8 pt-6 border-t border-gray-200 flex justify-between items-center">
                        <div>
                            <button type="button" 
                                    onclick="confirmDelete()"
                                    class="px-5 py-2.5 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium">
                                Delete Pet
                            </button>
                        </div>
                        
                        <div class="flex space-x-3">
                            <a href="{{ route('pets.index') }}" 
                               class="px-5 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium">
                                Cancel
                            </a>
                            <button type="submit" 
                                    class="px-5 py-2.5 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors font-medium">
                                Update Pet
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        
        <!-- Delete Form (Hidden) -->
        <form id="deleteForm" action="{{ route('pets.destroy', $pet->id) }}" method="POST" class="hidden">
            @csrf
            @method('DELETE')
        </form>
    </div>

    <script>
        // Image Preview Function
        function previewImage(event) {
            const input = event.target;
            const preview = document.getElementById('imagePreview');
            const currentImage = document.getElementById('currentImage');
            const placeholder = document.getElementById('placeholderIcon');
            const removeBtn = document.getElementById('removeImageBtn');
            const fileName = document.getElementById('fileName');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.classList.remove('hidden');
                    if (currentImage) currentImage.classList.add('hidden');
                    if (placeholder) placeholder.classList.add('hidden');
                    removeBtn.classList.remove('hidden');
                    fileName.textContent = `Selected: ${input.files[0].name}`;
                }
                
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // Remove New Image Function
        function removeImage() {
            const preview = document.getElementById('imagePreview');
            const currentImage = document.getElementById('currentImage');
            const placeholder = document.getElementById('placeholderIcon');
            const removeBtn = document.getElementById('removeImageBtn');
            const fileInput = document.getElementById('image');
            const fileName = document.getElementById('fileName');
            
            preview.classList.add('hidden');
            if (currentImage) currentImage.classList.remove('hidden');
            if (placeholder) placeholder.classList.remove('hidden');
            removeBtn.classList.add('hidden');
            fileInput.value = '';
            fileName.textContent = '';
        }
        
        // Confirm Delete Function
        function confirmDelete() {
            if (confirm('Are you sure you want to delete {{ $pet->name }}? This action cannot be undone.')) {
                document.getElementById('deleteForm').submit();
            }
        }
        
        // Drag and Drop Support
        const dropzone = document.getElementById('imageDropzone');
        const fileInput = document.getElementById('image');
        
        dropzone.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropzone.classList.add('border-gray-400', 'bg-gray-50');
        });
        
        dropzone.addEventListener('dragleave', () => {
            dropzone.classList.remove('border-gray-400', 'bg-gray-50');
        });
        
        dropzone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropzone.classList.remove('border-gray-400', 'bg-gray-50');
            
            if (e.dataTransfer.files.length) {
                fileInput.files = e.dataTransfer.files;
                const event = new Event('change', { bubbles: true });
                fileInput.dispatchEvent(event);
            }
        });
        
        // Form Validation
        document.getElementById('petForm').addEventListener('submit', function(e) {
            const fileInput = document.getElementById('image');
            const maxSize = 2 * 1024 * 1024; // 2MB
            
            if (fileInput.files[0] && fileInput.files[0].size > maxSize) {
                e.preventDefault();
                alert('Image size must be less than 2MB');
                return false;
            }
        });
    </script>
@endsection