import '../../../../domain/entities/entities.dart';

// Subscription ransaction List model (Will call in subs_record_model.dart)

class SubsTransactionModel extends SubsTransactionEntity {
  const SubsTransactionModel({
    required super.id,
    super.date,
    super.time,
    super.code,
    super.subName,
    super.merchantName,
    super.outletPlace,
  });

  factory SubsTransactionModel.fromJson(Map<String, dynamic> json) {
    return SubsTransactionModel(
      id: json['id'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      code: json['code'] ?? '',
      subName: json['subName'] ?? '',
      merchantName: json['merchantName'] ?? '',
      outletPlace: json['outletPlace'] ?? '',
    );
  }
}
