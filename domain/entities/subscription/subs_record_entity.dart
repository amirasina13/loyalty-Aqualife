import '../entities.dart';
import '../entity.dart';

// Subscription Record entity. Will call in subscription_hisory_entity.dart

class SubsRecordsEntity extends Entity<String> {
  final String? date;
  final List<SubsTransactionEntity>? transactions;

  const SubsRecordsEntity({
    required String id,
    this.date,
    this.transactions,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        date,
        transactions,
      ];
}
