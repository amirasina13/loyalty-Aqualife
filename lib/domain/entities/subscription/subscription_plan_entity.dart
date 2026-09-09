import '../entity.dart';

// Subscription list entity. Also will call in profile/home_page_entity.dart

class SubscriptionPlansEntity extends Entity<int> {
  final int? subId;
  final String? image;
  final String? name;
  final String? desc;
  final String? credits;
  final String? period;
  final String? periodType;
  final bool? isMuslim;
  final String? muslimCategory;

  const SubscriptionPlansEntity({
    required int id,
    this.subId,
    this.image,
    this.name,
    this.desc,
    this.credits,
    this.period,
    this.periodType,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        subId,
        image,
        name,
        desc,
        credits,
        period,
        periodType,
        isMuslim,
        muslimCategory,
      ];
}
