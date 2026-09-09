import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Merchant categories model

class MerchantCategoryModel extends MerchantCategoryEntity {
  const MerchantCategoryModel({
    required super.id,
    CategoryModel? super.all,
    CategoryModel? super.aj,
    CategoryModel? super.kt,
    CategoryModel? super.uz,
    CategoryModel? super.others,
  });

  factory MerchantCategoryModel.fromJson(Map<String, dynamic> json) {
    var all = CategoryModel.fromJson(json['all']);
    var aj = CategoryModel.fromJson(json['aj']);
    var kt = CategoryModel.fromJson(json['kt']);
    var uz = CategoryModel.fromJson(json['uz']);
    var others = CategoryModel.fromJson(json['others']);

    return MerchantCategoryModel(
      id: json['id'] ?? 1,
      all: all,
      aj: aj,
      kt: kt,
      uz: uz,
      others: others,
    );
  }
}
