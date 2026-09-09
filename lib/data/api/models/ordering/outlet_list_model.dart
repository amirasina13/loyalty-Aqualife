import '../../../../domain/entities/entities.dart';
import '../models.dart';

// List outlet list model

class OutletListModel extends OutletListEntity {
  const OutletListModel({
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
    super.distance,
    super.start,
    super.end,
    super.isOpen,
    super.oPermissions,
    PermissionsModel? super.permissions,
  });

  factory OutletListModel.fromJson(Map<String, dynamic> json) {
    return OutletListModel(
      id: json['id'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      distance: json['distance'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      isOpen: json['isOpen'],
      oPermissions: json['oPermissions'] ?? '',
      permissions: PermissionsModel.fromJson(json['permissions']),
    );
  }
}
