import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Credits records model (will call in credit_history_model.dart)

class CreditRecordsModel extends CreditRecordsEntity {
  const CreditRecordsModel({
    required super.id,
    super.date,
    List<CreditTransactionModel>? super.transaction,
  });

  factory CreditRecordsModel.fromJson(Map<String, dynamic> json) {
    List<CreditTransactionModel> transaction = [];
    if (json['transactions'] != null) {
      for (var s in (json['transactions'] as List)) {
        {
          transaction.add(CreditTransactionModel.fromJson(s));
        }
      }
    }

    return CreditRecordsModel(
      id: '1',
      date: json['date'],
      transaction: transaction,
    );
  }
}
