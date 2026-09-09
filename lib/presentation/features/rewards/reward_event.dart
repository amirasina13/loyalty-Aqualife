import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RewardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class RewardReload extends RewardEvent {}

@immutable
class FilterCategoryLoad extends RewardEvent {}

@immutable
class RewardListLoad extends RewardEvent {
  final String filterBy;
  final String filterValue;

  RewardListLoad({
    required this.filterBy,
    required this.filterValue,
  });

  @override
  List<Object> get props => [
        filterBy,
        filterValue,
      ];
}

@immutable
class RewardFilterListLoad extends RewardEvent {
  final String updateFilterBy;
  final String updateFilterValue;

  RewardFilterListLoad({
    required this.updateFilterBy,
    required this.updateFilterValue,
  });

  @override
  List<Object> get props => [
        updateFilterBy,
        updateFilterValue,
      ];
}

@immutable
class RewardMerchantLoad extends RewardEvent {
  final int merchantId;

  RewardMerchantLoad({
    required this.merchantId,
  });

  @override
  List<Object> get props => [
        merchantId,
      ];
}

@immutable
class RewardScannerLoad extends RewardEvent {}

@immutable
class RewardDownload extends RewardEvent {
  final int voucherId;
  final String pin;
  final String referral;

  RewardDownload({
    required this.voucherId,
    required this.pin,
    required this.referral,
  });

  @override
  List<Object> get props => [
        voucherId,
        pin,
        referral,
      ];
}

@immutable
class RewardPurchaseLoad extends RewardEvent {
  final int voucherId;
  final String redeemVia;
  final String pin;
  final String points;
  final String referral;
  final String quantity;

  RewardPurchaseLoad({
    required this.voucherId,
    required this.redeemVia,
    required this.pin,
    required this.points,
    required this.referral,
    required this.quantity,
  });

  @override
  List<Object> get props => [
        voucherId,
        redeemVia,
        pin,
        points,
        referral,
        quantity,
      ];
}

@immutable
class RewardDetailsLoad extends RewardEvent {
  final int rewardId;

  RewardDetailsLoad({
    required this.rewardId,
  });

  @override
  List<Object> get props => [
        rewardId,
      ];
}

@immutable
class RewardDetailsDynamicLoad extends RewardEvent {
  final String code;

  RewardDetailsDynamicLoad({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}

@immutable
class RewardRedeemQrLoad extends RewardEvent {
  final String code;

  RewardRedeemQrLoad({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}

@immutable
class RewardOutletCheck extends RewardEvent {}

@immutable
class RewardOutletsLoad extends RewardEvent {
  final String rewardId;

  RewardOutletsLoad({
    required this.rewardId,
  });

  @override
  List<Object> get props => [
        rewardId,
      ];
}

@immutable
class RewardOutletDetailsLoad extends RewardEvent {
  final int outletId;

  RewardOutletDetailsLoad({
    required this.outletId,
  });

  @override
  List<Object> get props => [
        outletId,
      ];
}

@immutable
class RewardAddRemoveFavouriteLoad extends RewardEvent {
  final String voucherId;

  RewardAddRemoveFavouriteLoad({
    required this.voucherId,
  });

  @override
  List<Object> get props => [
        voucherId,
      ];
}

@immutable
class RewardFavouriteLoad extends RewardEvent {}

@immutable
class RewardOutletLocationEnable extends RewardEvent {}

@immutable
class RewardOutletLocationDisable extends RewardEvent {}
