import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Point history model

class SubscriptionHistoryModel extends SubscriptionHistoryEntity {
  const SubscriptionHistoryModel({
    required super.id,
    List<SubsRecordsModel>? super.records,
    super.next,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    List<SubsRecordsModel> records = [];
    if (json['records'] != null) {
      for (var s in (json['records'] as List)) {
        {
          records.add(SubsRecordsModel.fromJson(s));
        }
      }
    }

    return SubscriptionHistoryModel(
      id: '1',
      records: records,
      next: json['next'],
    );
  }
}
