import '../entity.dart';

// Plan entity. Will call in subscription_details_entity.dart

class PlanEntity extends Entity<int> {
  final String? image;
  final String? name;
  final String? desc;
  final String? code;
  final String? credits;
  final String? redeemAmount;
  final String? redeemPeriod;
  final String? period;
  final String? periodType;
  final String? status;
  final bool? isMuslim;
  final String? muslimCategory;
  final String? content;

  const PlanEntity({
    required int id,
    this.image,
    this.name,
    this.desc,
    this.code,
    this.credits,
    this.redeemAmount,
    this.redeemPeriod,
    this.period,
    this.periodType,
    this.status,
    this.isMuslim,
    this.muslimCategory,
    this.content,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        image,
        name,
        desc,
        code,
        credits,
        redeemAmount,
        redeemPeriod,
        period,
        periodType,
        status,
        isMuslim,
        muslimCategory,
        content,
      ];
}
