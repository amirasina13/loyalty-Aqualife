import '../../../../domain/entities/entities.dart';
import '../models.dart';

// My Voucher Model

class VoucherDataModel extends VoucherDataEntity {
  const VoucherDataModel({
    required super.id,
    MemberModel? super.member,
    // final MerchantCategoryModel? merchants,
    List<VoucherModel>? super.vouchers,
  });

  factory VoucherDataModel.fromJson(Map<String, dynamic> json) {
    var member = MemberModel.fromJson(json['member']);
    // var merchants = MerchantCategoryModel.fromJson(json['vouchers']);

    List<VoucherModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherModel.fromJson(s));
        }
      }
    }

    return VoucherDataModel(
      id: json['id'] ?? '',
      member: member,
      vouchers: vouchers,
    );
  }
}
