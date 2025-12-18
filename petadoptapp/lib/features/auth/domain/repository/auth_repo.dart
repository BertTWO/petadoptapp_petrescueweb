// lib/domain/repositories/auth_repository.dart

import 'package:petadoptapp/features/auth/domain/entity/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String location,
  });
  Future<void> signOut();
  Stream<AppUser?> get user;
  AppUser? get currentUser;
}
