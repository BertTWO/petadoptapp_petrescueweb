import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petadoptapp/features/pet/domain/entity/pet.dart';
import 'package:petadoptapp/features/pet/domain/repository/pet_repo.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository petRepository;

  PetCubit({required this.petRepository}) : super(PetInitial());

  Future<void> fetchAllPets() async {
    emit(PetLoading());
    try {
      final pets = await petRepository.getAllPets();
      emit(PetLoaded(pets: pets));
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> fetchAvailablePets() async {
    emit(PetLoading());
    try {
      final pets = await petRepository.getAvailablePets();
      emit(PetLoaded(pets: pets));
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> fetchPetsByType(String type) async {
    emit(PetLoading());
    try {
      final pets = await petRepository.getPetsByType(type);
      emit(PetLoaded(pets: pets));
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> fetchPetsByOwner(String ownerId) async {
    emit(PetLoading());
    try {
      final pets = await petRepository.getPetsByOwner(ownerId);
      emit(PetLoaded(pets: pets));
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> addPet(Pet pet, File? imageFile) async {
    try {
      await petRepository.addPet(pet, imageFile);
      emit(const PetActionSuccess(message: 'Pet added successfully'));
      // Refresh the list
      fetchAvailablePets();
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> updatePet(Pet pet, File? imgFile) async {
    try {
      await petRepository.updatePet(pet, imgFile);
      emit(const PetActionSuccess(message: 'Pet updated successfully'));
      // Refresh the list
      fetchAvailablePets();
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await petRepository.deletePet(petId);
      emit(const PetActionSuccess(message: 'Pet deleted successfully'));
      // Refresh the list
      fetchAvailablePets();
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  void reset() {
    emit(PetInitial());
  }
}
