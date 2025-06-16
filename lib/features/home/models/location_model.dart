import 'package:recoding_platform_project/features/login/data/models/user_model.dart';

class Location {
  final int id;
  final String name;
  final String? subAspect;
  final String? category;
  final String? description;
  final int userId;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<dynamic> images;
  final List<dynamic> references;
  final String? aspect;

  Location({
    required this.id,
    required this.name,
    this.subAspect,
    this.category,
    this.description,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.images,
    required this.references,
    this.aspect,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      subAspect: json['sub_aspect'],
      category: json['category'],
      description: json['description'],
      userId: json['user_id'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      images: json['images'] ?? [],
      references: json['references'] ?? [],
      aspect: json['aspect'],
    );
  }
}

class LocationResponse {
  final String message;
  final Location location;

  LocationResponse({
    required this.message,
    required this.location,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      message: json['message'],
      location: Location.fromJson(json['location']),
    );
  }
}
