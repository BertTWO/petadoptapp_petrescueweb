<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Animal Rescue by Lance Garrett</title>
    @vite('resources/css/app.css')
</head>
<body class="bg-linear-to-br from-amber-50 via-orange-50 to-rose-50 min-h-screen flex items-center justify-center p-5">
    <div class="grid md:grid-cols-2 max-w-6xl w-full bg-white rounded-3xl overflow-hidden shadow-2xl">
        <!-- Image Section -->
        <div class="hidden md:flex relative bg-linear-to-br from-amber-500 via-orange-500 to-rose-500 flex-col items-center justify-center p-16 overflow-hidden min-h-175">
            <!-- Decorative elements -->
            <div class="absolute w-96 h-96 bg-white/10 rounded-full -top-32 -right-32 blur-3xl"></div>
            <div class="absolute w-64 h-64 bg-white/10 rounded-full -bottom-20 -left-20 blur-2xl"></div>
            <div class="absolute top-10 right-10 w-24 h-24 border-4 border-white/20 rounded-full"></div>
            <div class="absolute bottom-16 left-16 w-32 h-32 border-4 border-white/20 rounded-2xl -rotate-12"></div>
            
            <div class="relative z-10 text-center text-white space-y-8">
                <div class="relative w-64 h-64 mx-auto mb-8">
                    <div class="absolute inset-0 bg-white/20 rounded-full blur-xl"></div>
                    <div class="relative w-full h-full bg-white rounded-full shadow-2xl flex items-center justify-center p-8 backdrop-blur-sm">
                        <img src="{{ asset('images/rescue_dog.png') }}"
                             alt="Pet Rescue"
                             class="w-full h-full object-contain drop-shadow-lg">
                    </div>
                    <!-- Floating elements -->
                    <div class="absolute -top-4 -left-4 w-14 h-14 bg-white/30 rounded-full animate-pulse"></div>
                    <div class="absolute -bottom-6 -right-6 w-12 h-12 bg-white/20 rounded-full animate-bounce"></div>
                </div>

                <div class="space-y-4">
                    <h2 class="text-5xl font-bold leading-tight">Join Our Mission!</h2>
                    <p class="text-lg opacity-95 leading-relaxed max-w-md mx-auto">
                        Become part of a community dedicated to rescuing and protecting animals. Every member makes a difference.
                    </p>
                    <div class="flex items-center justify-center gap-8 pt-6">
    <div class="text-center max-w-xs">
        <div class="text-3xl font-bold">Lance Garrett</div>
        <div class="text-sm opacity-90">Building a better future for our community.</div>
    </div>
    
    <div class="w-px h-12 bg-white/30"></div>
    
    <div class="text-center max-w-xs">
        <div class="text-3xl font-bold">Fill Edward</div>
        <div class="text-sm opacity-90">Your voice and your support make the difference.</div>
    </div>
</div>
                </div>
            </div>
        </div>
        
        <!-- Form Section -->
        <div class="flex flex-col justify-center p-10 lg:p-16 bg-linear-to-br from-white to-amber-50/30">
            <!-- Logo -->
            <div class="flex items-center gap-3 mb-10">
                <div class="w-12 h-12 bg-linear-to-br from-amber-500 to-rose-500 rounded-2xl flex items-center justify-center shadow-lg">
                    <img src="{{ asset('images/logo.png') }}"
                         alt="Pet Rescue Center"
                         class="w-7 h-7 object-contain brightness-0 invert">
                </div>
                <div>
                    <div class="text-2xl font-bold text-gray-800 leading-none">Lance Garrett's</div>
                    <div class="text-sm text-gray-500 font-medium">Animal Rescue</div>
                </div>
            </div>
            
            <h1 class="text-4xl font-bold text-gray-800 mb-3">Create Your Account</h1>
            <p class="text-gray-600 mb-7">Fill in your details to start making a difference</p>
            
            <!-- Error Messages -->
            @if ($errors->any())
                <div class="bg-red-50 text-red-700 px-5 py-4 rounded-xl mb-6 border border-red-100">
                    <div class="flex items-start gap-3">
                        <svg class="w-5 h-5 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"/>
                        </svg>
                        <ul class="list-disc list-inside space-y-1 text-sm">
                            @foreach ($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                </div>
            @endif
            
            <form action="{{ route('register') }}" method="POST" class="space-y-5">
                @csrf
                <div>
                    <label class="block text-gray-700 font-semibold mb-2.5 text-sm">Full Name</label>
                    <input type="text" name="name" value="{{ old('name') }}" required
                           placeholder="John Doe"
                           class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl bg-white transition-all duration-200 focus:outline-none focus:border-amber-400 focus:ring-4 focus:ring-amber-100 placeholder:text-gray-400">
                </div>
                
                <div>
                    <label class="block text-gray-700 font-semibold mb-2.5 text-sm">Email Address</label>
                    <input type="email" name="email" value="{{ old('email') }}" required
                           placeholder="your.email@example.com"
                           class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl bg-white transition-all duration-200 focus:outline-none focus:border-amber-400 focus:ring-4 focus:ring-amber-100 placeholder:text-gray-400">
                </div>
                
                <div>
                    <label class="block text-gray-700 font-semibold mb-2.5 text-sm">Password</label>
                    <input type="password" name="password" required
                           placeholder="Create a strong password"
                           class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl bg-white transition-all duration-200 focus:outline-none focus:border-amber-400 focus:ring-4 focus:ring-amber-100 placeholder:text-gray-400">
                </div>
                
                <div>
                    <label class="block text-gray-700 font-semibold mb-2.5 text-sm">Confirm Password</label>
                    <input type="password" name="password_confirmation" required
                           placeholder="Re-enter your password"
                           class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl bg-white transition-all duration-200 focus:outline-none focus:border-amber-400 focus:ring-4 focus:ring-amber-100 placeholder:text-gray-400">
                </div>
                
                <div class="pt-2">
                    <label class="flex items-start gap-3 cursor-pointer group">
                        <input type="checkbox" required class="w-5 h-5 mt-0.5 text-amber-500 border-2 border-gray-300 rounded focus:ring-2 focus:ring-amber-500 cursor-pointer shrink-0">
                        <span class="text-sm text-gray-600 group-hover:text-gray-800 transition-colors">
                            I agree to the 
                            <a href="#" class="text-amber-500 hover:text-amber-600 font-semibold">Terms of Service</a> 
                            and 
                            <a href="#" class="text-amber-500 hover:text-amber-600 font-semibold">Privacy Policy</a>
                        </span>
                    </label>
                </div>
                
                <button type="submit" 
                        class="w-full py-4 bg-linear-to-r from-amber-500 via-orange-500 to-rose-500 text-white rounded-xl font-bold text-lg shadow-xl shadow-orange-200 hover:shadow-2xl hover:shadow-orange-300 hover:-translate-y-1 transition-all duration-200 active:translate-y-0">
                    Create Account
                </button>
            </form>
            
            <div class="relative my-7">
                <div class="absolute inset-0 flex items-center">
                    <div class="w-full border-t-2 border-gray-200"></div>
                </div>
                <div class="relative flex justify-center text-sm">
                    <span class="px-4 bg-linear-to-br from-white to-amber-50/30 text-gray-500 font-medium">or sign up with</span>
                </div>
            </div>
            
            <div class="grid grid-cols-2 gap-4 mb-6">
                <button class="flex items-center justify-center gap-3 px-4 py-3.5 border-2 border-gray-200 rounded-xl bg-white hover:border-amber-400 hover:bg-amber-50 hover:shadow-lg transition-all font-medium text-sm group">
                    <svg class="w-5 h-5" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
                    <span class="group-hover:text-gray-800">Google</span>
                </button>
                <button class="flex items-center justify-center gap-3 px-4 py-3.5 border-2 border-gray-200 rounded-xl bg-white hover:border-amber-400 hover:bg-amber-50 hover:shadow-lg transition-all font-medium text-sm group">
                    <svg class="w-5 h-5" fill="#1877F2" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                    <span class="group-hover:text-gray-800">Facebook</span>
                </button>
            </div>
            
            <div class="text-center">
                <p class="text-gray-600 text-sm">
                    Already have an account? 
                    <a href="{{ route('login') }}"
                       class="text-amber-500 font-bold hover:text-amber-600 transition-colors">
                       Sign In →
                    </a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>