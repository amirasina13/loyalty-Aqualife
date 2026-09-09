import '../entity.dart';

// My subscription list entity

class MySubscriptionPlanEntity extends Entity<int> {
  final int? rId;
  final String? code;
  final int? subId;
  final String? subName;
  final String? image;
  final String? date;
  final String? nextRecurring;
  final String? credits;
  final bool? isRecurring;
  final bool? isMuslim;
  final String? muslimCategory;

  const MySubscriptionPlanEntity({
    required int id,
    this.rId,
    this.code,
    this.subId,
    this.subName,
    this.image,
    this.date,
    this.nextRecurring,
    this.credits,
    this.isRecurring,
    this.isMuslim,
    this.muslimCategory,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        rId,
        code,
        subId,
        subName,
        image,
        date,
        nextRecurring,
        credits,
        isRecurring,
        isMuslim,
        muslimCategory,
      ];
}
