// lib/features/adoption/domain/entities/adoption_application.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ApplicationStatus { pending, approved, rejected, cancelled }

class AdoptionApplication extends Equatable {
  final String id;
  final String petId;
  final String userId;
  final String message;
  final ApplicationStatus status;
  final DateTime appliedAt;

  // From API relationships
  final Map<String, dynamic>? pet;
  final Map<String, dynamic>? user;

  const AdoptionApplication({
    required this.id,
    required this.petId,
    required this.userId,
    required this.message,
    required this.status,
    required this.appliedAt,
    this.pet,
    this.user,
  });

  // Factory from Laravel API
  factory AdoptionApplication.fromJson(Map<String, dynamic> json) {
    return AdoptionApplication(
      id: json['id'].toString(),
      petId: json['pet_id'].toString(),
      userId: json['user_id'].toString(),
      message: json['notes'] ?? '',
      status: _stringToStatus(json['status'] ?? 'pending'),
      appliedAt: DateTime.parse(
        json['adoption_date'] ??
            json['created_at'] ??
            DateTime.now().toString(),
      ),
      pet: json['pet'] is Map ? Map<String, dynamic>.from(json['pet']) : null,
      user: json['user'] is Map
          ? Map<String, dynamic>.from(json['user'])
          : null,
    );
  }

  // Factory for new application
  factory AdoptionApplication.createNew({
    required String petId,
    required String userId,
    required String message,
  }) {
    return AdoptionApplication(
      id: '', // Will be set by API
      petId: petId,
      userId: userId,
      message: message,
      status: ApplicationStatus.pending,
      appliedAt: DateTime.now(),
    );
  }

  // Status helpers
  static ApplicationStatus _stringToStatus(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'cancelled':
        return ApplicationStatus.cancelled;
      case 'pending':
      default:
        return ApplicationStatus.pending;
    }
  }

  static String _statusToString(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.approved:
        return 'approved';
      case ApplicationStatus.rejected:
        return 'rejected';
      case ApplicationStatus.cancelled:
        return 'cancelled';
      case ApplicationStatus.pending:
        return 'pending';
    }
  }

  // Helper getters
  String get petName => pet?['name'] ?? 'Unknown Pet';
  String get petImageUrl => pet?['image_url'] ?? '';
  String get userName => user?['name'] ?? 'Unknown User';
  String get userEmail => user?['email'] ?? '';

  bool get isPending => status == ApplicationStatus.pending;
  bool get isApproved => status == ApplicationStatus.approved;
  bool get isRejected => status == ApplicationStatus.rejected;
  bool get isCancelled => status == ApplicationStatus.cancelled;

  String get statusText {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.cancelled:
        return Colors.grey;
    }
  }

  // For sending to API
  Map<String, dynamic> toApiJson() {
    return {'notes': message};
  }

  @override
  List<Object?> get props => [id, petId, userId, status, appliedAt];
}
