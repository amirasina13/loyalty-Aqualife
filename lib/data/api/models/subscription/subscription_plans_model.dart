import '../../../../domain/entities/entities.dart';

// Subscription model

class SubscriptionPlansModel extends SubscriptionPlansEntity {
  const SubscriptionPlansModel({
    required super.id,
    super.subId,
    super.image,
    super.name,
    super.desc,
    super.credits,
    super.period,
    super.periodType,
    super.isMuslim,
    super.muslimCategory,
  });

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansModel(
      id: json['subId'],
      subId: json['subId'],
      image: json['image'],
      name: json['name'],
      desc: json['desc'],
      credits: json['credits'],
      period: json['period'],
      periodType: json['periodType'],
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'],
    );
  }
}
