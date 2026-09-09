import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Reward Model

class RewardDataModel extends RewardDataEntity {
  const RewardDataModel({
    required super.id,
    MemberModel? super.member,
    List<VoucherRewardModel>? super.vouchers,
    super.next,
  });

  factory RewardDataModel.fromJson(Map<String, dynamic> json) {
    var member = MemberModel.fromJson(json['member']);
    // var vouchers = VoucherCategoryModel.fromJson(json['vouchers']);
    List<VoucherRewardModel> vouchers = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          vouchers.add(VoucherRewardModel.fromJson(s));
        }
      }
    }

    return RewardDataModel(
      id: json['id'] ?? '',
      member: member,
      vouchers: vouchers,
      next: json['next'],
    );
  }
}
