// lib/features/pet/domain/repository/pet_repo.dart
import 'dart:async';
import 'dart:io';
import '../entity/pet.dart';

abstract class PetRepository {
  // Get pets
  Future<List<Pet>> getAllPets();
  Future<List<Pet>> getAvailablePets();
  Future<List<Pet>> getPetsByType(String type);
  Future<Pet?> getPetById(String petId);
  Stream<List<Pet>> watchAvailablePets();

  // Adoption actions (for adopters)
  Future<Map<String, dynamic>> adoptPet(String petId, {String? notes});
  Future<Map<String, dynamic>> cancelAdoption(String petId);
  Future<List<dynamic>> getMyAdoptions();

  @Deprecated('Adopters cannot add pets - use web dashboard')
  Future<void> addPet(Pet pet, File? imageFile);

  @Deprecated('Adopters cannot update pets - use web dashboard')
  Future<void> updatePet(Pet pet, File? imageFile);

  @Deprecated('Adopters cannot delete pets - use web dashboard')
  Future<void> deletePet(String petId);

  @Deprecated('Mobile app doesn\'t track pet owners')
  Future<List<Pet>> getPetsByOwner(String ownerId);
}
