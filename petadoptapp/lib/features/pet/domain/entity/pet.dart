class Pet {
  final String id;
  final String name;
  final String type; // Dog, Cat, Bird, etc.
  final String breed;
  final int age;
  final String location;
  final String status; // available, pending, adopted
  final String displayImage; // This will contain the full URL
  final String? description;
  final String? gender;
  final DateTime? createdAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.location,
    required this.status,
    required this.displayImage,
    this.description,
    this.gender,
    this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    // First, try to get the image from 'image_url' (Laravel accessor)
    // Then try 'displayImage', then 'image'
    String getImageUrl() {
      if (json['image_url'] != null &&
          json['image_url'].toString().isNotEmpty) {
        return json['image_url'].toString();
      }
      if (json['displayImage'] != null &&
          json['displayImage'].toString().isNotEmpty) {
        return json['displayImage'].toString();
      }
      if (json['image'] != null && json['image'].toString().isNotEmpty) {
        final image = json['image'].toString();
        // If it's already a full URL, return it
        if (image.startsWith('http')) {
          return image;
        }
        // Otherwise, construct the full URL
        const baseUrl = 'http://192.168.100.2:8000';
        if (image.startsWith('/')) {
          return baseUrl + image;
        }
        return '$baseUrl/storage/pets/$image';
      }
      return ''; // Return empty if no image
    }

    return Pet(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] is int
          ? json['age']
          : int.tryParse(json['age'].toString()) ?? 0,
      location: json['location'] ?? '',
      status: (json['status']?.toString().toLowerCase() ?? 'available'),
      displayImage: getImageUrl(), // This will now have the correct URL
      description: json['description']?.toString(),
      gender: json['gender']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'location': location,
      'status': status,
      'displayImage': displayImage,
      'description': description,
      'gender': gender,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  bool get isAvailable => status == 'available';
  bool get isPending => status == 'pending';
  bool get isAdopted => status == 'adopted';

  @override
  String toString() {
    return 'Pet{id: $id, name: $name, displayImage: $displayImage}';
  }
}
