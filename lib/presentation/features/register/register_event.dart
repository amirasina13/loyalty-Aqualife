import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class RegisterVerify extends RegisterEvent {
  final String email;

  RegisterVerify({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

@immutable
class RegisterPressed extends RegisterEvent {
  final String email;
  final String password;
  final String referral;
  final String vToken;

  RegisterPressed({
    required this.email,
    required this.password,
    required this.referral,
    required this.vToken,
  });

  @override
  List<Object> get props => [email, password, referral, vToken];
}

@immutable
class RegisterReferDecrypt extends RegisterEvent {
  final String referCode;

  RegisterReferDecrypt({required this.referCode});

  @override
  List<Object> get props => [
        referCode,
      ];

  @override
  String toString() => 'ReferDecryptValue';
}
