import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OrderingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class OrderingCheck extends OrderingEvent {}

@immutable
class BrandsLoad extends OrderingEvent {
  final int categoryId;
  final bool loadingFirst;

  BrandsLoad({
    required this.categoryId,
    required this.loadingFirst,
  });

  @override
  List<Object> get props => [
        categoryId,
        loadingFirst,
      ];
}

@immutable
class NearbyLoad extends OrderingEvent {}

@immutable
class NearbySearch extends OrderingEvent {}

// @immutable
// class BrandsCheckingLoad extends OrderingEvent {}

@immutable
class OutletLoad extends OrderingEvent {
  final int brandId;

  OutletLoad({
    required this.brandId,
  });

  @override
  List<Object> get props => [
        brandId,
      ];
}

@immutable
class OutletAddRemoveFavouriteLoad extends OrderingEvent {
  final String merchantId;

  OutletAddRemoveFavouriteLoad({
    required this.merchantId,
  });

  @override
  List<Object> get props => [
        merchantId,
      ];
}

@immutable
class MerchantBookmarkLoad extends OrderingEvent {}

@immutable
class OutletMerchantLoad extends OrderingEvent {}

@immutable
class OrderingLocationEnable extends OrderingEvent {}

@immutable
class OrderingLocationDisable extends OrderingEvent {}
