import '../../../../domain/entities/transfer/verify_transfer_entity.dart';
import 'receiver_model.dart';
import 'sender_model.dart';

// Verify transfer data model
class VerifyTransferModel extends VerifyTransferEntity {
  const VerifyTransferModel({
    required super.id,
    SenderModel? super.profile,
    ReceiverModel? super.receiver,
  });

  factory VerifyTransferModel.fromJson(Map<String, dynamic> json) {
    var profile = SenderModel.fromJson(json['profile']);
    var receiver = ReceiverModel.fromJson(json['receiver']);

    return VerifyTransferModel(
      id: profile.id,
      profile: profile,
      receiver: receiver,
    );
  }
}
