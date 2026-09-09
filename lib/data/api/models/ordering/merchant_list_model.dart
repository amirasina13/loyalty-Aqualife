import '../../../../domain/entities/entities.dart';

// Merchant list model

class MerchantListModel extends MerchantListEntity {
  const MerchantListModel({
    required super.id,
    super.name,
    super.color,
    super.image,
    super.isMuslim,
    super.muslimCategory,
    super.total,
    // final List<DeliveryLinkModel>? external,
  });

  factory MerchantListModel.fromJson(Map<String, dynamic> json) {
    // List<DeliveryLinkModel> external = [];
    // if (json['external'] != null) {
    //   for (var s in (json['external'] as List)) {
    //     {
    //       external.add(DeliveryLinkModel.fromJson(s));
    //     }
    //   }
    // }

    return MerchantListModel(
      id: json['id'],
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
      isMuslim: json['isMuslim'],
      muslimCategory: json['muslimCategory'] ?? '',
      total: json['total'] ?? 0,
      // external: external,
    );
  }
}
