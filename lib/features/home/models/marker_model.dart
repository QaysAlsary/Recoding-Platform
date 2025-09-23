class MarkerData {
  final int id;
  final String name;
  final String aspect;
  final String subAspect;
  final String category;
  final double latitude;
  final double longitude;
  final String description;
  final List<MarkerImage> images;

  MarkerData({
    required this.id,
    required this.name,
    required this.aspect,
    required this.subAspect,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.images,
  });

  factory MarkerData.fromJson(Map<String, dynamic> json) {
    return MarkerData(
      id: json['id'],
      name: json['name'],
      aspect: json['aspect'],
      subAspect: json['sub_aspect'],
      category: json['category'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      description: json['description'],
      images: (json['images'] as List?)
          ?.map((img) => MarkerImage.fromJson(img))
          .toList() ??
          [],
    );
  }
}

class MarkerImage {
  final int id;
  final int locationId;
  final String imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarkerImage({
    required this.id,
    required this.locationId,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarkerImage.fromJson(Map<String, dynamic> json) {
    return MarkerImage(
      id: json['id'],
      locationId: json['location_id'],
      imagePath: json['image_path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}