import '../../../../domain/entities/transfer/sender_entity.dart';

// Sender model (will call in verify_transfer_model.dart)
class SenderModel extends SenderEntity {
  const SenderModel({
    required super.id,
    super.membershipId,
    super.membershipName,
    super.membershipBG,
    super.image,
    super.code,
    super.name,
    super.surname,
    super.forename,
    super.dob,
    super.contact,
    super.cCode,
    super.cValid,
    super.email,
    super.eValid,
    super.points,
    super.credits,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['id'],
      membershipId: json['membershipId'],
      membershipBG: json['membershipBG'],
      image: json['image'],
      code: json['code'],
      name: json['name'],
      surname: json['surname'],
      forename: json['forename'],
      dob: json['dob'],
      contact: json['contact'],
      cCode: json['cCode'],
      cValid: json['cValid'],
      email: json['email'],
      eValid: json['eValid'],
      points: json['points'],
      credits: json['credits'],
    );
  }
}
