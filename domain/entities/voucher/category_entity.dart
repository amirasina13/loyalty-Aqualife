import '../entities.dart';
import '../entity.dart';

// Categories entity

class CategoryEntity extends Entity<int> {
  final String? name;
  final int? total;
  final List<VoucherEntity>? vouchers;

  const CategoryEntity({
    required int id,
    this.name,
    this.total,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        total,
        vouchers,
      ];
}
