import 'dart:convert';

import 'package:config/config_global.dart';

import '../../config/server_addresses.dart';

enum RequestType {
  post,
  get,
  put,
  delete,
}

class HttpClient {
  Map<String, String> createHeader({required RequestType type}) {
    switch (type) {
      case RequestType.post:
        {
          var header = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }..addAll(_getBasicAuthHeader());

          return header;
        }
      case RequestType.get:
        return _getBasicAuthHeader();
      case RequestType.put:
        return _getBasicAuthHeader();
      case RequestType.delete:
        return _getBasicAuthHeader();
    }
  }

  Map<String, String> _getBasicAuthHeader() {
    return <String, String>{
      'authorization':
          'Basic ${base64Encode(utf8.encode('$apiUsername:${_generatePassword()}'))}'
    };
  }

  Uri createUri(String route, [Map<String, dynamic> param = const {}]) {
    var uri = Uri.parse(ServerAddresses.serverAddress + route);
    var url = uri.replace(queryParameters: param);

    return url;
  }

  String _generatePassword() {
    return apiPwd;
  }
}
