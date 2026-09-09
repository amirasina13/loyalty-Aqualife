import '../../../../../domain/entities/entities.dart';

// Highlight model (will call in home_page_model.dart)

class HighlightModel extends HighlightEntity {
  const HighlightModel({
    required super.id,
    super.name,
    super.image,
    super.isClickable,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isClickable: json['isClickable'] ?? '',
    );
  }
}
