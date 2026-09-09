import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Subscription List Model

class SubscriptionDataModel extends SubscriptionDataEntity {
  const SubscriptionDataModel({
    required super.id,
    MemberModel? super.member,
    List<SubscriptionPlansModel>? super.plans,
  });

  factory SubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    var member = MemberModel.fromJson(json['member']);
    // var plans = RewardModel.fromJson(json['plans']);
    List<SubscriptionPlansModel> plans = [];
    if (json['plans'] != null) {
      for (var s in (json['plans'] as List)) {
        {
          plans.add(SubscriptionPlansModel.fromJson(s));
        }
      }
    }

    return SubscriptionDataModel(
      id: json['id'] ?? '',
      member: member,
      plans: plans,
    );
  }
}
