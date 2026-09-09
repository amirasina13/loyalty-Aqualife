import '../../../../../domain/entities/entities.dart';
import '../../models.dart';

// Reward data details model

class FilterDataModel extends FilterDataEntity {
  const FilterDataModel({
    required super.id,
    super.title,
    List<OptionsCategoryModel>? super.options,
    super.input,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) {
    List<OptionsCategoryModel> options = [];
    if (json['options'] != null) {
      for (var s in (json['options'] as List)) {
        {
          options.add(OptionsCategoryModel.fromJson(s));
        }
      }
    }

    return FilterDataModel(
      id: json['id'] ?? '',
      title: json['title'],
      options: options,
      input: json['input'],
    );
  }
}
