// lib/presentation/bloc/auth/auth_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadoptapp/features/auth/domain/entity/app_user.dart';
import 'package:petadoptapp/features/auth/domain/repository/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  bool _isInitialLoadComplete = false;

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    _authListener();
    _checkInitialAuth();
  }

  void _authListener() {
    authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        // Only emit Unauthenticated if initial load is complete
        if (_isInitialLoadComplete) {
          emit(AuthUnauthenticated());
        }
      }
    });
  }

  Future<void> _checkInitialAuth() async {
    try {
      // Check if we have a user already loaded
      final currentUser = authRepository.currentUser;

      if (currentUser != null) {
        emit(AuthAuthenticated(user: currentUser));
      } else {
        // Give a small delay to ensure any async loading completes
        await Future.delayed(const Duration(milliseconds: 500));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    } finally {
      _isInitialLoadComplete = true;
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String location,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
        location: location,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
