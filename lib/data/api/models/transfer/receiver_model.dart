import '../../../../domain/entities/transfer/receiver_entity.dart';

// Receiver model (will call in verify_transfer_model.dart)
class ReceiverModel extends ReceiverEntity {
  const ReceiverModel({
    required super.id,
    super.name,
    super.contact,
    super.code,
    super.image,
    super.push,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> json) {
    return ReceiverModel(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      code: json['code'],
      image: json['image'],
      push: json['push'],
    );
  }
}
