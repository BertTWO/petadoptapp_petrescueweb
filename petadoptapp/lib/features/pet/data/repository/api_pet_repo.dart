import 'dart:async';
import 'dart:io';
import 'package:petadoptapp/features/pet/domain/entity/pet.dart';
import 'package:petadoptapp/features/pet/domain/repository/pet_repo.dart';
import 'package:petadoptapp/core/services/api_service.dart';

class ApiPetRepository implements PetRepository {
  final ApiService _apiService = ApiService();
  final StreamController<List<Pet>> _petsStreamController =
      StreamController<List<Pet>>.broadcast();

  @override
  Future<List<Pet>> getAllPets() async {
    try {
      final response = await _apiService.get('/pets');
      if (response['success'] == true) {
        final List<dynamic> petsJson = response['data'];
        return petsJson.map((json) => Pet.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch pets: ${response['message']}');
    } catch (e) {
      throw Exception('Failed to fetch all pets: $e');
    }
  }

  @override
  Future<List<Pet>> getAvailablePets() async {
    // Note: Your API already returns only available pets
    return getAllPets();
  }

  @override
  Future<List<Pet>> getPetsByType(String type) async {
    try {
      final response = await _apiService.get('/pets/search?type=$type');
      if (response['success'] == true) {
        final List<dynamic> petsJson = response['data'];
        return petsJson.map((json) => Pet.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch pets by type: ${response['message']}');
    } catch (e) {
      throw Exception('Failed to fetch pets by type: $e');
    }
  }

  @override
  Future<List<Pet>> getPetsByOwner(String ownerId) async {
    // Mobile app doesn't need this - only shelter staff in web dashboard
    throw UnimplementedError('getPetsByOwner not available in mobile app');
  }

  @override
  Future<Pet?> getPetById(String petId) async {
    try {
      final response = await _apiService.get('/pets/$petId');
      if (response['success'] == true) {
        return Pet.fromJson(response['data']);
      }
      throw Exception('Failed to fetch pet: ${response['message']}');
    } catch (e) {
      throw Exception('Failed to fetch pet by ID: $e');
    }
  }

  @override
  Future<void> updatePet(Pet pet, [File? imageFile]) {
    // Adopters cannot update pets - only shelter staff
    throw UnimplementedError('Adopters cannot update pets');
  }

  @override
  Future<void> deletePet(String petId) {
    // Adopters cannot delete pets - only shelter staff
    throw UnimplementedError('Adopters cannot delete pets');
  }

  @override
  Future<void> addPet(Pet pet, [File? imageFile]) {
    // Adopters cannot add pets - only shelter staff
    throw UnimplementedError('Adopters cannot add pets');
  }

  @override
  Stream<List<Pet>> watchAvailablePets() {
    // Start periodic updates
    _startStreamUpdates();
    return _petsStreamController.stream;
  }

  void _startStreamUpdates() async {
    try {
      final pets = await getAvailablePets();
      _petsStreamController.add(pets);
    } catch (e) {
      _petsStreamController.addError(e);
    }

    // Poll every 30 seconds for updates
    Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        final pets = await getAvailablePets();
        _petsStreamController.add(pets);
      } catch (e) {
        // Don't close stream on error, just skip this update
      }
    });
  }

  @override
  Future<Map<String, dynamic>> adoptPet(String petId, {String? notes}) async {
    try {
      final response = await _apiService.post(
        '/pets/$petId/adopt',
        body: {'notes': notes},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to adopt pet: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> cancelAdoption(String petId) async {
    try {
      final response = await _apiService.post('/pets/$petId/cancel-adoption');
      return response;
    } catch (e) {
      throw Exception('Failed to cancel adoption: $e');
    }
  }

  @override
  Future<List<dynamic>> getMyAdoptions() async {
    try {
      final response = await _apiService.get('/pets/adoptions/my');
      if (response['success'] == true) {
        return response['data'];
      }
      throw Exception('Failed to fetch adoptions: ${response['message']}');
    } catch (e) {
      throw Exception('Failed to get adoption history: $e');
    }
  }

  @override
  void dispose() {
    _petsStreamController.close();
  }
}
