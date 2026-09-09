import '../entities.dart';
import '../entity.dart';

// Outlet details entity

class OutletDetailsEntity extends Entity<int> {
  final int? merchantId;
  final String? merchantName;
  final String? image;
  final String? place;
  final String? contact;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? merchantDesc;
  final List<OperationEntity>? operations;
  final List<OutletVoucherEntity>? vouchers;

  const OutletDetailsEntity({
    required int id,
    this.merchantId,
    this.merchantName,
    this.image,
    this.place,
    this.contact,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
    this.merchantDesc,
    this.operations,
    this.vouchers,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        merchantId,
        merchantName,
        image,
        place,
        contact,
        address,
        placeId,
        latitude,
        longitude,
        merchantDesc,
        operations,
        vouchers,
      ];
}
