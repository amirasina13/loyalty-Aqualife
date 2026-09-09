import '../../../../domain/entities/entities.dart';

// User referral code model

class UserReferModel extends UserReferEntity {
  const UserReferModel({
    required super.id,
    super.code,
    super.link,
    super.qr,
    super.barcode,
    super.text,
  });

  factory UserReferModel.fromJson(Map<String, dynamic> json) {
    return UserReferModel(
      id: json['code'],
      code: json['code'],
      link: json['link'],
      qr: json['qr'],
      barcode: json['barcode'],
      text: json['text'],
    );
  }
}
