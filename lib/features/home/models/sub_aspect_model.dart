class SubAspectModel {
  final int id;
  final String name;
  final int aspectId;
  final String? createdAt;
  final String? updatedAt;

  SubAspectModel({
    required this.id,
    required this.name,
    required this.aspectId,
    this.createdAt,
    this.updatedAt,
  });

  factory SubAspectModel.fromJson(Map<String, dynamic> json) {
    return SubAspectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      aspectId: json['aspect_id'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
