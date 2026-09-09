import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Subscription details model

class SubscriptionDetailsModel extends SubscriptionDetailsEntity {
  const SubscriptionDetailsModel({
    required super.id,
    PlanModel? super.plan,
    super.isSubscribe,
    super.isRecurring,
    super.nextRecurring,
    super.showQR,
    super.total,
    super.redeemed,
    super.available,
    super.qr,
    List<RewardOutletModel>? super.outlets,
  });

  factory SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    List<RewardOutletModel> outlets = [];
    if (json['outlets'] != null) {
      for (var s in (json['outlets'] as List)) {
        {
          outlets.add(RewardOutletModel.fromJson(s));
        }
      }
    }

    return SubscriptionDetailsModel(
      id: json['plan']['subId'],
      plan: PlanModel.fromJson(json['plan']),
      isSubscribe: json['isSubscribe'],
      isRecurring: json['isRecurring'],
      nextRecurring: json['nextRecurring'] ?? '',
      showQR: json['showQR'],
      total: json['total'],
      redeemed: json['redeemed'],
      available: json['available'],
      qr: json['qr'],
      outlets: outlets,
    );
  }
}
