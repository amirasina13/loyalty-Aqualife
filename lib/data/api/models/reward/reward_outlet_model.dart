import '../../../../domain/entities/entities.dart';

// Reward Outlet model (will call in details_data_model.dart)

class RewardOutletModel extends RewardOutletEntity {
  const RewardOutletModel({
    required super.id,
    super.merchantId,
    super.merchantName,
    super.merchantImg,
    super.place,
    super.address,
    super.placeId,
    super.latitude,
    super.longitude,
    super.distance,
  });

  factory RewardOutletModel.fromJson(Map<String, dynamic> json) {
    return RewardOutletModel(
      id: json['id'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'] ?? '',
      merchantImg: json['merchantImg'] ?? '',
      place: json['place'] ?? '',
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      distance: json['distance'] ?? '',
    );
  }
}
