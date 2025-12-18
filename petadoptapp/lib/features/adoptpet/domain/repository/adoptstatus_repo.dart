// lib/features/adoptpet/domain/repository/adoptstatus_repo.dart
import 'dart:async';
import 'package:petadoptapp/features/adoptpet/domain/entity/adoptpet.dart';

abstract class AdoptionRepository {
  // For adopters
  Future<void> submitAdoptionApplication(AdoptionApplication application);
  Future<List<AdoptionApplication>> getMyApplications(String adopterId);
  Future<void> cancelApplication(String applicationId);

  // For owners
  Future<List<AdoptionApplication>> getApplicationsForOwner(String ownerId);
  Future<List<AdoptionApplication>> getApplicationsForPet(String petId);
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? rejectionReason,
  });

  // Streams for real-time updates
  Stream<List<AdoptionApplication>> watchApplicationsForOwner(String ownerId);
  Stream<List<AdoptionApplication>> watchMyApplications(String adopterId);

  // Additional methods (optional but useful)
  Future<AdoptionApplication?> getApplicationById(String applicationId);
  Future<int> getPendingApplicationsCount(String ownerId);
  Future<bool> hasAppliedForPet(String adopterId, String petId);
  Stream<int> watchPendingApplicationsCount(String ownerId);
}
