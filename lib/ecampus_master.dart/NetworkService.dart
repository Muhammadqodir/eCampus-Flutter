import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  final JsonEncoder _encoder = const JsonEncoder();

  Map<String, String> headers = {"content-type": "application/json"};
  Map<String, String> cookies = {};

  void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String? rawCookie) {
    if (rawCookie != null) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += key + "=" + cookies[key]!;
    }

    return cookie;
  }

  Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    _updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, {body, encoding}) async {
    http.Response response = await http.post(Uri.parse(url),
        body: _encoder.convert(body), headers: headers, encoding: encoding);
    _updateCookie(response);
    return response;
  }
}
