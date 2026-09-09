import '../entities.dart';
import '../entity.dart';

// Subscription details entity

class SubscriptionDetailsEntity extends Entity<int> {
  final PlanEntity? plan;
  final bool? isSubscribe;
  final bool? isRecurring;
  final bool? showQR;
  final String? qr;
  final List<RewardOutletEntity>? outlets;
  final int? total;
  final int? redeemed;
  final int? available;
  final String? nextRecurring;

  const SubscriptionDetailsEntity({
    required int id,
    this.plan,
    this.isSubscribe,
    this.isRecurring,
    this.showQR,
    this.qr,
    this.outlets,
    this.total,
    this.redeemed,
    this.available,
    this.nextRecurring,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        plan,
        isSubscribe,
        isRecurring,
        showQR,
        qr,
        outlets,
        total,
        redeemed,
        available,
        nextRecurring,
      ];
}
