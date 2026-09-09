import '../entities.dart';
import '../entity.dart';

// Subscription history entity

class SubscriptionHistoryEntity extends Entity<String> {
  final List<SubsRecordsEntity>? records;
  final String? next;

  const SubscriptionHistoryEntity({
    required String id,
    this.records,
    this.next,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        records,
        next,
      ];
}
