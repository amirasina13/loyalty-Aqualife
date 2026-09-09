import '../../../../domain/entities/entities.dart';
import '../models.dart';

// Outlet details model

class OutletDetailsModel extends OutletDetailsEntity {
  const OutletDetailsModel({
    required super.id,
    super.merchantId,
    super.merchantName,
    super.image,
    super.place,
    super.contact,
    super.address,
    super.placeId,
    super.latitude,
    super.longitude,
    super.merchantDesc,
    List<OperationModel>? super.operations,
    List<OutletVoucherModel>? super.vouchers,
  });

  factory OutletDetailsModel.fromJson(Map<String, dynamic> json) {
    List<OperationModel> operation = [];
    if (json['operations'] != null) {
      for (var s in (json['operations'] as List)) {
        {
          operation.add(OperationModel.fromJson(s));
        }
      }
    }

    List<OutletVoucherModel> voucher = [];
    if (json['vouchers'] != null) {
      for (var s in (json['vouchers'] as List)) {
        {
          voucher.add(OutletVoucherModel.fromJson(s));
        }
      }
    }

    return OutletDetailsModel(
      id: json['merchantId'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      merchantDesc: json['merchantDesc'] ?? '',
      operations: operation,
      vouchers: voucher,
    );
  }
}
