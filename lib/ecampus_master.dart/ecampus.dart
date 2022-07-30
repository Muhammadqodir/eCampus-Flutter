import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';


class eCampus {
  String login = "";
  String password = "";

  eCampus(this.login, this.password);

  Future<String> getToken() async {
    http.Response response = await http.get(Uri.parse('https://ecampus.ncfu.ru/account/login'));
    var doc = parse(response.body);
    return doc.querySelector('[name="__RequestVerificationToken"]')!.attributes['value'] ?? "error";
  }

  Future<Uint8List> getCaptcha() async {
    http.Response response = await http.get(Uri.parse('https://ecampus.ncfu.ru/Captcha/Captcha'));
    return response.bodyBytes;
  }

  Future<String> authenticate() async {
    String token = await getToken();
    
    http.Response response = await http.get(Uri.parse('https://ecampus.ncfu.ru/Captcha/Captcha'));
    
    print(response.statusCode);
    print(response.bodyBytes);
    return "ok";
  }

}