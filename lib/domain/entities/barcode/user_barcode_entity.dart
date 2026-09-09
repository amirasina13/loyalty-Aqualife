import '../entities.dart';
import '../entity.dart';

// Qrcode for user entity

class UserQrcodeEntity extends Entity<int> {
  final ProfileBarcodeEntity? profile;
  final String? qr;
  final String? barcode;

  const UserQrcodeEntity({
    required int id,
    this.profile,
    this.qr,
    this.barcode,
  }) : super(id);

  @override
  List<Object?> get props => [id, profile, qr, barcode];
}
