import '../../../../domain/entities/entities.dart';
import '../models.dart';

// User member card model

class UserMembercardeModel extends UserQrcodeEntity {
  const UserMembercardeModel({
    required super.id,
    ProfileBarcodeModel? super.profile,
    super.qr,
    super.barcode,
  });

  factory UserMembercardeModel.fromJson(Map<String, dynamic> json) {
    var profile = ProfileBarcodeModel.fromJson(json['profile']);

    return UserMembercardeModel(
      id: profile.id,
      profile: profile,
      qr: json['qr'] ?? '',
      barcode: json['barcode'] ?? '',
    );
  }
}
