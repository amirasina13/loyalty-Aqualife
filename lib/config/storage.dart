import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage _instance = Storage._internal();

  factory Storage() => _instance;

  Storage._internal();

  // STORAGE
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String token = '';
  String otpToken = '';
  String contact = '';
  String email = '';
  String otp = '';
  String? distance = '';
  String? page = '';
  String reasonDelete = '';
  String lastUpdateCheck = '';
  String lastUpdateLoc = '';
  String set = '';
  String? brandName = '';
  String securityPin = '';
  int rewardId = 0;
  int voucherId = 0;
  int merchantId = 0;
  String? titlePasscodeRoute = '';
  String? welcomeSplash = '';
  String rewardReload = '';
  String? latitude = '3.1390';
  String? longitude = '101.6869';
  String? address = '';
  String? locPermission = '';
  Map? globalValue;
  int? orderingCheck = 0;
  Map? dataCheck;
  bool? setupDone;
  bool? isTabChange = false;
}
