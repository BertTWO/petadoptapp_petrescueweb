// lib/domain/entities/base_entity.dart
abstract class BaseEntity {
  Map<String, dynamic> toJson();
  String get id;
}
