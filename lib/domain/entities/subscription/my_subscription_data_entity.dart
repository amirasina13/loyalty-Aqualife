import '../entities.dart';
import '../entity.dart';

// My Subscription list entity

class MySubscriptionDataEntity extends Entity<String> {
  final MemberEntity? member;
  final List<MySubscriptionPlanEntity>? plans;
  final List<SubscriptionPlansEntity>? unsubscribe;

  const MySubscriptionDataEntity({
    required String id,
    this.member,
    this.plans,
    this.unsubscribe,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        member,
        plans,
        unsubscribe,
      ];
}
