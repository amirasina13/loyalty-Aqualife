import '../entities.dart';
import '../entity.dart';

// Merchant list entity

class NearbyOutletListEntity extends Entity<int> {
  final int? merchantId;
  final String? merchantName;
  final String? image;
  final String? place;
  final String? contact;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? distance;
  final String? oPermissions;
  final PermissionsEntity? permissions;

  const NearbyOutletListEntity({
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
    this.distance,
    this.oPermissions,
    this.permissions,
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
        distance,
        oPermissions,
        permissions,
      ];
}
