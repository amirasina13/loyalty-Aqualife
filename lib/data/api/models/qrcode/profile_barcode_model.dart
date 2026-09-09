import '../../../../domain/entities/entities.dart';

// Profile qrcode model (will call in user_barcode_model.dart)

class ProfileBarcodeModel extends ProfileBarcodeEntity {
  const ProfileBarcodeModel({
    required super.id,
    super.membershipId,
    super.membershipName,
    super.membershipBG,
    super.image,
    super.code,
    super.name,
    super.points,
    super.credits,
    super.coins,
  });

  factory ProfileBarcodeModel.fromJson(Map<String, dynamic> json) {
    return ProfileBarcodeModel(
      id: json['id'],
      membershipId: json['membershipId'],
      membershipName: json['membershipName'] ?? '',
      membershipBG: json['membershipBG'] ?? '',
      image: json['image'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      points: json['points'] ?? '',
      credits: json['credits'] ?? '',
      coins: json['coins'] ?? '',
    );
  }
}
