import '../entity.dart';

// Point transaction entity

class TransactionEntity extends Entity<int> {
  final String? tranNo;
  final String? tranDate;
  final String? date;
  final String? time;
  final String? type;
  final String? method;
  final String? points;
  final String? desc;

  const TransactionEntity({
    required int id,
    this.tranNo,
    this.tranDate,
    this.date,
    this.time,
    this.type,
    this.method,
    this.points,
    this.desc,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        tranNo,
        tranDate,
        date,
        time,
        type,
        method,
        points,
        desc,
      ];
}
