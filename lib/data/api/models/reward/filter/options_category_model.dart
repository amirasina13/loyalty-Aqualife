// Reward Outlet model (will call in details_data_model.dart)

import '../../../../../domain/entities/entities.dart';

class OptionsCategoryModel extends OptionsCategoryEntity {
  const OptionsCategoryModel({
    required super.id,
    super.name,
    super.image,
    super.filterBy,
  });

  factory OptionsCategoryModel.fromJson(Map<String, dynamic> json) {
    return OptionsCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      filterBy: json['filterBy'] ?? '',
    );
  }
}
