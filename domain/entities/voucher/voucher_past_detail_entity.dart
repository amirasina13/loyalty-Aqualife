import '../entity.dart';

// Voucher past entity

class VoucherPastDetailsEntity extends Entity<int> {
  final int? voucherId;
  final String? code;
  final String? image;
  final String? name;
  final String? desc;
  final bool? isUsed;
  final String? redeemAt;
  final bool? isExpired;
  final String? expiredAt;
  final int? rating;
  final String? comment;

  const VoucherPastDetailsEntity({
    required int id,
    this.voucherId,
    this.code,
    this.image,
    this.name,
    this.desc,
    this.isUsed,
    this.redeemAt,
    this.isExpired,
    this.expiredAt,
    this.rating,
    this.comment,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        voucherId,
        code,
        image,
        name,
        desc,
        isUsed,
        redeemAt,
        isExpired,
        expiredAt,
        rating,
        comment,
      ];
}
