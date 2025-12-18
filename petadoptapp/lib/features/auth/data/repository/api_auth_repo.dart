// lib/data/repositories/api_auth_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:petadoptapp/core/services/api_service.dart';
import 'package:petadoptapp/features/auth/domain/entity/app_user.dart';
import 'package:petadoptapp/features/auth/domain/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuthRepository implements AuthRepository {
  final ApiService _apiService = ApiService();
  final StreamController<AppUser?> _userController =
      StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;

  ApiAuthRepository() {
    _loadCurrentUser();
  }

  // Load current user from storage on init
  Future<void> _loadCurrentUser() async {
    try {
      print('Loading current user...');
      final token = await _apiService.getToken();
      print('Token found: ${token != null && token.isNotEmpty}');

      if (token != null && token.isNotEmpty) {
        try {
          print('Fetching profile...');
          final response = await _apiService.get('/profile');
          print('Profile response: $response');

          if (response['success'] == true && response.containsKey('user')) {
            _currentUser = AppUser.fromJson(response['user']);
            print('User loaded: ${_currentUser?.email}');
            _userController.add(_currentUser);
            return;
          }
        } catch (e) {
          print('Error fetching profile: $e');
          // Token is invalid, clear it
          await _apiService.clearToken();
        }
      }

      // No valid token or user found
      print('No valid user found, loading from local storage');
      final localUser = await _loadUserLocally();
      if (localUser != null) {
        _currentUser = localUser;
        _userController.add(_currentUser);
      } else {
        _currentUser = null;
        _userController.add(null);
      }
    } catch (e) {
      print('Error loading user: $e');
      _currentUser = null;
      _userController.add(null);
    }
  }

  @override
  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('Signing in with email: $email');
      final response = await _apiService.post(
        '/login',
        body: {'email': email, 'password': password},
        includeAuth: false,
      );

      print('Login response: $response');

      // Check response structure
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Login failed');
      }

      if (!response.containsKey('token')) {
        throw Exception('No token in response');
      }

      // Save token
      await _apiService.saveToken(response['token']);

      // Create AppUser from response
      _currentUser = AppUser.fromJson(response['user']);

      // Save user data locally
      await _saveUserLocally(_currentUser!);

      // Notify listeners
      _userController.add(_currentUser);

      return _currentUser;
    } catch (e) {
      print('Sign in error: $e');
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String location,
  }) async {
    try {
      print('Signing up with email: $email');
      final response = await _apiService.post(
        '/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'phone': phone,
          'address': location,
        },
        includeAuth: false,
      );

      print('Register response: $response');

      // Check response structure
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Registration failed');
      }

      if (!response.containsKey('token')) {
        throw Exception('No token in response');
      }

      // Save token
      await _apiService.saveToken(response['token']);

      // Create AppUser from response
      _currentUser = AppUser.fromJson(response['user']);

      // Save user data locally
      await _saveUserLocally(_currentUser!);

      // Notify listeners
      _userController.add(_currentUser);

      return _currentUser;
    } catch (e) {
      print('Sign up error: $e');
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      print('Signing out...');
      await _apiService.post('/logout');
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout API error: $e');
    } finally {
      await _apiService.clearToken();
      await _clearUserLocally();
      _currentUser = null;
      _userController.add(null);
      print('Sign out complete');
    }
  }

  @override
  Stream<AppUser?> get user => _userController.stream;

  @override
  AppUser? get currentUser => _currentUser;

  // Save user data to local storage
  Future<void> _saveUserLocally(AppUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = user.toJson();
      await prefs.setString('user_data', jsonEncode(userJson));
      print('User saved locally');
    } catch (e) {
      print('Error saving user locally: $e');
    }
  }

  // Load user data from local storage
  Future<AppUser?> _loadUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null && userData.isNotEmpty) {
        final userJson = jsonDecode(userData);
        print('Loaded user from local storage');
        return AppUser.fromJson(userJson);
      }
    } catch (e) {
      print('Error loading user locally: $e');
      await _clearUserLocally();
    }
    return null;
  }

  // Clear user data from local storage
  Future<void> _clearUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    print('User cleared from local storage');
  }

  // Dispose stream controller
  void dispose() {
    _userController.close();
  }
}
