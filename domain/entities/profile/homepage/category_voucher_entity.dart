import '../../entities.dart';
import '../../entity.dart';

// Category Voucher list entity

class CategoryVoucherEntity extends Entity<int> {
  final String? name;
  final String? image;
  final String? filterBy;
  final List<VouchersCatEntity>? vouchers;

  const CategoryVoucherEntity({
    required int id,
    this.name,
    this.image,
    this.filterBy,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        filterBy,
        vouchers,
      ];
}
