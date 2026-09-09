import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Category model

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    super.name,
    super.total,
    List<VoucherModel>? super.vouchers,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<VoucherModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherModel.fromJson(s));
        }
      }
    }

    return CategoryModel(
      id: json['id'] ?? 1,
      name: json['name'] ?? '',
      total: json['total'] ?? 0,
      vouchers: vouchers,
    );
  }
}
