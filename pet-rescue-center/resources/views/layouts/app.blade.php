<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Pet Rescue Admin')</title>
    @vite('resources/css/app.css')
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body class="bg-gray-50 min-h-screen">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200">
        <div class="container mx-auto px-6 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-4">
                    <div class="w-10 h-10 bg-gray-900 rounded-lg flex items-center justify-center">
                        <img src="{{ asset('images/logo.png') }}" alt="Logo" class="w-6 h-6 brightness-0 invert">
                    </div>
                    <div>
                        <div class="text-lg font-semibold text-gray-900">Pet Rescue Center</div>
                        <div class="text-sm text-gray-500">Admin Dashboard</div>
                    </div>
                </div>

                <div class="flex items-center space-x-6">
                    <div class="text-right">
                        <div class="font-medium text-gray-900">{{ Auth::user()->name }}</div>
                        <div class="text-sm text-gray-500">{{ Auth::user()->user_type }}</div>
                    </div>
                    
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit" class="px-4 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors text-sm font-medium">
                            Sign Out
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </header>

    <div class="flex min-h-screen">
        <!-- Sidebar Navigation -->
        <nav class="w-64 bg-white border-r border-gray-200">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Navigation</h2>
            </div>
            
            <div class="p-4 space-y-1">
                <a href="/dashboard" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-gray-50 hover:text-gray-900 rounded-lg transition-colors">
                    <i class="fas fa-tachometer-alt w-5"></i>
                    <span class="font-medium">Dashboard</span>
                </a>
                
                <a href="{{ route('pets.index') }}" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-gray-50 hover:text-gray-900 rounded-lg transition-colors">
                    <i class="fas fa-dog w-5"></i>
                    <span class="font-medium">Pets Management</span>
                </a>
                
                <a href="{{ route('pets.adoptions') }}" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-gray-50 hover:text-gray-900 rounded-lg transition-colors">
                    <i class="fas fa-heart w-5"></i>
                    <span class="font-medium">Adoptions</span>
                </a>
                
                <a href="/users" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-gray-50 hover:text-gray-900 rounded-lg transition-colors">
                    <i class="fas fa-users w-5"></i>
                    <span class="font-medium">Users</span>
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="flex-1 p-8">
            @if(session('success'))
                <div class="mb-6 bg-green-50 border border-green-200 text-green-800 px-5 py-4 rounded-lg">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle mr-3"></i>
                        <span>{{ session('success') }}</span>
                    </div>
                </div>
            @endif

            @if(session('error'))
                <div class="mb-6 bg-red-50 border border-red-200 text-red-800 px-5 py-4 rounded-lg">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle mr-3"></i>
                        <span>{{ session('error') }}</span>
                    </div>
                </div>
            @endif

            @yield('content')
        </main>
    </div>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6">
        <div class="container mx-auto px-6">
            <div class="flex justify-between items-center">
                <div class="text-gray-600">
                    <p class="font-medium">Pet Rescue Center Admin System</p>
                    <p class="text-sm">© {{ date('Y') }} All rights reserved</p>
                </div>
                <div class="text-sm text-gray-500">
                    v1.0.0 • System Status: <span class="text-green-600 font-medium">Online</span>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>