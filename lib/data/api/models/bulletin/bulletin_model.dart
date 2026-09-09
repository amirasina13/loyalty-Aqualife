import '../../../../domain/entities/entities.dart';

// Bulletin List model

class BulletinModel extends BulletinEntity {
  const BulletinModel({
    required super.id,
    super.name,
    super.image,
  });

  factory BulletinModel.fromJson(Map<String, dynamic> json) {
    return BulletinModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
