import '../entities.dart';
import '../entity.dart';

// Voucher by categories entity

class VoucherCategoriesEntity extends Entity<int> {
  final String? name;
  final String? image;
  final int? total;
  final List<VoucherEntity>? vouchers;

  const VoucherCategoriesEntity({
    required int id,
    this.name,
    this.image,
    this.total,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        total,
        vouchers,
      ];
}
