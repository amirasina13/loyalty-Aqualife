import '../entities.dart';
import '../entity.dart';

// Subscription list entity

class SubscriptionDataEntity extends Entity<String> {
  final MemberEntity? member;
  final List<SubscriptionPlansEntity>? plans;

  const SubscriptionDataEntity({
    required String id,
    this.member,
    this.plans,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        member,
        plans,
      ];
}
