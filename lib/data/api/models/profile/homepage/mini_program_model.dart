import '../../../../../domain/entities/entities.dart';

// Mini model (will call in home_page_model.dart)

class MiniProgramModel extends MiniProgramEntity {
  const MiniProgramModel({
    required super.id,
    super.name,
    super.image,
    super.url,
    super.appId,
    super.isVerified,
  });

  factory MiniProgramModel.fromJson(Map<String, dynamic> json) {
    return MiniProgramModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      appId: json['appId'] ?? '',
      isVerified: json['isVerified'] ?? '',
    );
  }
}
