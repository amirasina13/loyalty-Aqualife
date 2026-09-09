import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Category model

class CategoryRewardModel extends CategoryRewardEntity {
  const CategoryRewardModel({
    required super.id,
    super.name,
    List<VoucherRewardModel>? super.vouchers,
  });

  factory CategoryRewardModel.fromJson(Map<String, dynamic> json) {
    List<VoucherRewardModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherRewardModel.fromJson(s));
        }
      }
    }

    return CategoryRewardModel(
      id: json['id'] ?? 1,
      name: json['name'] ?? '',
      vouchers: vouchers,
    );
  }
}
