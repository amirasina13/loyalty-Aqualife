import '../../../../domain/entities/entities.dart';

// Plan model (will call in subscription_details.dart.dart)

class PlanModel extends PlanEntity {
  const PlanModel({
    required super.id,
    // int? subId,
    super.image,
    super.name,
    super.desc,
    super.code,
    super.credits,
    super.redeemAmount,
    super.redeemPeriod,
    super.period,
    super.periodType,
    super.status,
    super.isMuslim,
    super.muslimCategory,
    super.content,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['subId'],
      // subId: json['subId'],
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      code: json['code'] ?? '',
      credits: json['credits'] ?? '',
      redeemAmount: json['redeemAmount'] ?? '',
      redeemPeriod: json['redeemPeriod'] ?? '',
      period: json['period'] ?? '',
      periodType: json['periodType'] ?? '',
      status: json['status'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
