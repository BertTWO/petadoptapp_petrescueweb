// lib/features/adoption/data/repositories/adoption_repository_impl.dart
import 'dart:async';
import 'package:petadoptapp/core/services/api_service.dart';
import 'package:petadoptapp/features/adoptpet/domain/entity/adoptpet.dart';
import 'package:petadoptapp/features/adoptpet/domain/repository/adoptstatus_repo.dart';

class ApiAdoptionRepository implements AdoptionRepository {
  final ApiService _apiService = ApiService();
  final StreamController<List<AdoptionApplication>> _myApplicationsController =
      StreamController<List<AdoptionApplication>>.broadcast();

  @override
  Future<void> submitAdoptionApplication(
    AdoptionApplication application,
  ) async {
    try {
      final response = await _apiService.post(
        '/pets/${application.petId}/adopt',
        body: application.toApiJson(),
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to submit application');
      }
    } catch (e) {
      throw Exception('Failed to submit adoption application: $e');
    }
  }

  @override
  Future<List<AdoptionApplication>> getMyApplications(String userId) async {
    try {
      final response = await _apiService.get('/pets/adoptions/my');

      if (response['success'] == true) {
        final List<dynamic> adoptionsJson = response['data'];
        return adoptionsJson.map((json) {
          return AdoptionApplication.fromJson(json);
        }).toList();
      }
      throw Exception('Failed to fetch applications: ${response['message']}');
    } catch (e) {
      throw Exception('Failed to get adoption applications: $e');
    }
  }

  @override
  Future<List<AdoptionApplication>> getApplicationsForOwner(
    String ownerId,
  ) async {
    throw UnimplementedError('Users cannot view other applications');
  }

  @override
  Future<List<AdoptionApplication>> getApplicationsForPet(String petId) async {
    throw UnimplementedError('Users cannot view pet applications');
  }

  @override
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? rejectionReason,
  }) async {
    throw UnimplementedError('Users cannot update application status');
  }

  @override
  Future<void> cancelApplication(String applicationId) async {
    try {
      // Get applications to find pet ID
      final applications = await getMyApplications('');
      final application = applications.firstWhere(
        (app) => app.id == applicationId,
        orElse: () => throw Exception('Application not found'),
      );

      // Call cancel endpoint
      final response = await _apiService.post(
        '/pets/${application.petId}/cancel-adoption',
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to cancel application');
      }
    } catch (e) {
      throw Exception('Failed to cancel adoption: $e');
    }
  }

  @override
  Stream<List<AdoptionApplication>> watchApplicationsForOwner(String ownerId) {
    throw UnimplementedError('Users cannot watch other applications');
  }

  @override
  Stream<List<AdoptionApplication>> watchMyApplications(String userId) {
    // Initial load
    _loadMyApplications(userId);

    // Poll every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      _loadMyApplications(userId);
    });

    return _myApplicationsController.stream;
  }

  void _loadMyApplications(String userId) async {
    try {
      final applications = await getMyApplications(userId);
      _myApplicationsController.add(applications);
    } catch (e) {
      // Don't close stream on error
    }
  }

  @override
  Future<AdoptionApplication?> getApplicationById(String applicationId) async {
    try {
      final applications = await getMyApplications('');
      return applications.firstWhere((app) => app.id == applicationId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> getPendingApplicationsCount(String userId) async {
    try {
      final applications = await getMyApplications(userId);
      return applications.where((app) => app.isPending).length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<bool> hasAppliedForPet(String userId, String petId) async {
    try {
      final applications = await getMyApplications(userId);
      return applications.any((app) => app.petId == petId && app.isPending);
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<int> watchPendingApplicationsCount(String userId) {
    final controller = StreamController<int>();

    void updateCount() async {
      try {
        final count = await getPendingApplicationsCount(userId);
        controller.add(count);
      } catch (e) {
        // Ignore
      }
    }

    // Initial
    updateCount();

    // Poll every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      updateCount();
    });

    return controller.stream;
  }

  void dispose() {
    _myApplicationsController.close();
  }
}
