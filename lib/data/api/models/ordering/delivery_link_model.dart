import '../../../../domain/entities/entities.dart';

// Merchant list model

class DeliveryLinkModel extends DeliveryLinkEntity {
  const DeliveryLinkModel({
    required super.id,
    super.type,
    super.url,
    super.isAllow,
  });

  factory DeliveryLinkModel.fromJson(Map<String, dynamic> json) {
    List<DeliveryLinkModel> external = [];
    if (json['external'] != null) {
      for (var s in (json['external'] as List)) {
        {
          external.add(DeliveryLinkModel.fromJson(s));
        }
      }
    }

    return DeliveryLinkModel(
      id: 0,
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      isAllow: json['isAllow'],
    );
  }
}
