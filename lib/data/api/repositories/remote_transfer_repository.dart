import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/server_addresses.dart';
import '../../error/exceptions.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import '../models/models.dart';
import '../utils.dart';

// Calling API function for transfer credit (FOR TRANSFER PAGE)
class RemoteTransferRepository extends TransferRepository {
  // Verify user to transfer
  @override
  Future<dynamic> verifyTransfer({
    required String token,
    required String qrCode,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifyTransfer);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'qrCode': qrCode,
    });

    try {
      var response = await http.post(
        route,
        headers: header,
        body: data,
      );
      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw jsonResponse['message'];
          }
        } else {
          return jsonResponse;
        }

        return VerifyTransfer.fromEntity(
            VerifyTransferModel.fromJson(jsonResponse['data']));
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        rethrow;
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }

  // transfer credit to others
  @override
  Future<dynamic> transferCredit({
    required String token,
    required String qrCode,
    required String amount,
    required String pin,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.transferCredit);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'qrCode': qrCode,
      'amount': amount,
      'pin': pin,
    });

    try {
      var response = await http.post(
        route,
        headers: header,
        body: data,
      );

      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        if (!jsonResponse['isMaintenance']) {
          if (!jsonResponse['session']) {
            throw InvalidSessionException(message: jsonResponse['message']);
          }

          if (!jsonResponse['status']) {
            throw jsonResponse['message'];
          }
        } else {
          return jsonResponse;
        }

        return jsonResponse['message'];
      }
    } catch (e) {
      if (e is InvalidStatusException) {
        rethrow;
      } else if (e is Exception) {
        throw Exception('Something is wrong. Please try again later.');
      } else {
        rethrow;
      }
    }
  }
}
