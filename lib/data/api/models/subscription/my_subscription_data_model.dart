import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Subscription List Model

class MySubscriptionDataModel extends MySubscriptionDataEntity {
  const MySubscriptionDataModel({
    required super.id,
    MemberModel? super.member,
    List<MySubscriptionPlanModel>? super.plans,
    List<SubscriptionPlansModel>? super.unsubscribe,
  });

  factory MySubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    var member = MemberModel.fromJson(json['member']);

    List<MySubscriptionPlanModel> plans = [];
    if (json['plans'] != null) {
      for (var s in (json['plans'] as List)) {
        {
          plans.add(MySubscriptionPlanModel.fromJson(s));
        }
      }
    }

    List<SubscriptionPlansModel> unsubscribe = [];
    if (json['unsubscribe'] != null) {
      for (var s in (json['unsubscribe'] as List)) {
        {
          unsubscribe.add(SubscriptionPlansModel.fromJson(s));
        }
      }
    }

    return MySubscriptionDataModel(
      id: json['id'] ?? '',
      member: member,
      plans: plans,
      unsubscribe: unsubscribe,
    );
  }
}
