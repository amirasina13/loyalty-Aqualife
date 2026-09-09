import '../entity.dart';

/* Reward/ IF Perks outlet entity. Will call in details_data_entity.dart 
& subscription/subscription_details_entity.dart & voucher/details_entity.dart */

class RewardOutletEntity extends Entity<int> {
  final int? merchantId;
  final String? merchantName;
  final String? merchantImg;
  final String? place;
  final String? address;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? distance;

  const RewardOutletEntity({
    required int id,
    this.merchantId,
    this.merchantName,
    this.merchantImg,
    this.place,
    this.address,
    this.placeId,
    this.latitude,
    this.longitude,
    this.distance,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        merchantId,
        merchantName,
        merchantImg,
        place,
        address,
        placeId,
        latitude,
        longitude,
        distance,
      ];
}
