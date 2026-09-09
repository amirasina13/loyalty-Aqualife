import '../../../../domain/entities/entities.dart';

// My Subscription model

class MySubscriptionPlanModel extends MySubscriptionPlanEntity {
  const MySubscriptionPlanModel({
    required super.id,
    super.rId,
    super.code,
    super.subId,
    super.subName,
    super.image,
    super.date,
    super.nextRecurring,
    super.credits,
    super.isRecurring,
    super.isMuslim,
    super.muslimCategory,
  });

  factory MySubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionPlanModel(
      id: json['rId'],
      rId: json['rId'],
      code: json['code'],
      subId: json['subId'],
      subName: json['subName'],
      image: json['image'],
      date: json['date'],
      nextRecurring: json['nextRecurring'],
      credits: json['credits'],
      isRecurring: json['isRecurring'],
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'],
    );
  }
}
