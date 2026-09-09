import '../entities.dart';
import '../entity.dart';

// Categories entity

class CategoryRewardEntity extends Entity<int> {
  final String? name;
  final List<VoucherRewardEntity>? vouchers;

  const CategoryRewardEntity({
    required int id,
    this.name,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        vouchers,
      ];
}
