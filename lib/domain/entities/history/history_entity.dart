import '../entities.dart';
import '../entity.dart';

// Point history entity

class HistoryEntity extends Entity<String> {
  final List<RecordsEntity>? records;
  final String? next;

  const HistoryEntity({
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
