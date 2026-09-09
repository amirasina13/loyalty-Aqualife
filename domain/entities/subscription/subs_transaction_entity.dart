import '../entity.dart';

// Subscription transaction entity. Will call in subs_record_entity.dart

class SubsTransactionEntity extends Entity<int> {
  final String? date;
  final String? time;
  final String? code;
  final String? subName;
  final String? merchantName;
  final String? outletPlace;

  const SubsTransactionEntity({
    required int id,
    this.date,
    this.time,
    this.code,
    this.subName,
    this.merchantName,
    this.outletPlace,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        date,
        time,
        code,
        subName,
        merchantName,
        outletPlace,
      ];
}
