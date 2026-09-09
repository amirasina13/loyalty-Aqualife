import '../../../../domain/entities/entities.dart';

// Credit payment model

class CreditPaymentModel extends CreditPaymentEntity {
  const CreditPaymentModel({
    required super.id,
    super.qr,
    super.credits,
  });

  factory CreditPaymentModel.fromJson(Map<String, dynamic> json) {
    return CreditPaymentModel(
      id: json['id'] ?? '',
      qr: json['qr'] ?? '',
      credits: json['credits'] ?? '',
    );
  }
}
