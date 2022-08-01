import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class NetworkService {
  
  Map<String, String> headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7",
    "Cache-Control": "max-age=0",
    "Connection": "keep-alive",
    "Content-Type": "application/x-www-form-urlencoded",
    "Host":"ecampus.ncfu.ru",
    "Origin": "https://ecampus.ncfu.ru",
    "Referer": "https://ecampus.ncfu.ru/account/login",
    "sec-ch-ua": '".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"macOS"',
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "same-origin",
    "Sec-Fetch-User": "?1",
    "Upgrade-Insecure-Requests": "1",
    };
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

      headers['Cookie'] = _generateCookieHeader();
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

  void addCookie(String key, String value){
    cookies.addAll({key: value});
    headers['Cookie'] = _generateCookieHeader();
  }

  void setContentLength(int length){
    // headers['Content-Length'] = length.toString();
  }

  void clearCookies(){
    cookies.clear();
    headers['Cookie'] = _generateCookieHeader();
  }

  Future<http.Response> get(String url) async {
    headers.remove("Content-Length");
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    _updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, {body}) async {
    log( jsonEncode(headers));
    http.Response response = await http.post(Uri.parse(url),
        body: body, headers: headers);
    _updateCookie(response);
    return response;
  }
}
