// lib/domain/entities/favorite.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final String id;
  final String petId;
  final String userId;
  final DateTime addedDate;

  const Favorite({
    required this.id,
    required this.petId,
    required this.userId,
    required this.addedDate,
  });

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Favorite(
      id: doc.id,
      petId: data['petId'] ?? '',
      userId: data['userId'] ?? '',
      addedDate: (data['addedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'userId': userId,
      'addedDate': Timestamp.fromDate(addedDate),
    };
  }

  @override
  List<Object> get props => [id];
}
