import '../entity.dart';

// Sender entity. Will call in verify_transfer_entity.dart

class SenderEntity extends Entity<int> {
  final int? membershipId;
  final String? membershipName;
  final String? membershipBG;
  final String? image;
  final String? code;
  final String? name;
  final String? surname;
  final String? forename;
  final String? dob;
  final String? contact;
  final String? cCode;
  final bool? cValid;
  final String? email;
  final bool? eValid;
  final String? points;
  final String? credits;

  const SenderEntity({
    required int id,
    this.membershipId,
    this.membershipName,
    this.membershipBG,
    this.image,
    this.code,
    this.name,
    this.surname,
    this.forename,
    this.dob,
    this.contact,
    this.cCode,
    this.cValid,
    this.email,
    this.eValid,
    this.points,
    this.credits,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        membershipId,
        membershipName,
        membershipBG,
        image,
        code,
        name,
        surname,
        forename,
        dob,
        contact,
        cCode,
        cValid,
        email,
        eValid,
        points,
        credits,
      ];
}
