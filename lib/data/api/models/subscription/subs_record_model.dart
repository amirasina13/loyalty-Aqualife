import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Subscription records model (Will call in Subscription_history_model.dart)

class SubsRecordsModel extends SubsRecordsEntity {
  const SubsRecordsModel({
    required super.id,
    super.date,
    List<SubsTransactionModel>? super.transactions,
  });

  factory SubsRecordsModel.fromJson(Map<String, dynamic> json) {
    List<SubsTransactionModel> transactions = [];
    if (json['transactions'] != null) {
      for (var s in (json['transactions'] as List)) {
        {
          transactions.add(SubsTransactionModel.fromJson(s));
        }
      }
    }

    return SubsRecordsModel(
      id: '1',
      date: json['date'],
      transactions: transactions,
    );
  }
}
