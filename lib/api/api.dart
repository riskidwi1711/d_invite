import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:d_invite/const/config.dart';

class CallApi{
  final String _url = '${base_url}api/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  logOutData(String token) async {
    var fullUrl = Uri.parse('http://10.0.2.2:8000/api/logout');
    return await http.post(fullUrl, headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"});
  }

  _setHeaders()  => {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
