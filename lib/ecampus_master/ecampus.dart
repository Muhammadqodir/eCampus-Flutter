import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/NetworkService.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';


class eCampus {
  final JsonEncoder _encoder = const JsonEncoder();
  NetworkService client = new NetworkService();
  String login = "";
  String password = "";

  eCampus();

  Future<String> getToken() async {
    http.Response response = await client.get('https://ecampus.ncfu.ru/account/login');
    var doc = parse(response.body);
    return doc.querySelector('[name="__RequestVerificationToken"]')!.attributes['value'] ?? "error";
  }

  Future<Uint8List> getCaptcha() async {
    http.Response response = await client.get('https://ecampus.ncfu.ru/Captcha/Captcha');
    return response.bodyBytes;
  }

  String getCookies(){
    return _encoder.convert(client.cookies);
  }

  Future<AuthenticateResponse> authenticate(String username, String password, String captcha) async {
    String token = await getToken();

    Map<String, String> body = {
      '__RequestVerificationToken': token,
      'Login': username,
      'Password': password,
      'Code': captcha,
      'RememberMe': "true"
    };
    client.setContentLength(body.length);
    http.Response response = await client.post('https://ecampus.ncfu.ru/Account/Login',
    body: body);
    if(response.statusCode == 302){
      http.Response home = await client.post('https://ecampus.ncfu.ru');
      var doc = parse(home.body);

      String userName = doc.getElementsByClassName("username")[0].innerHtml;
      String cookie = client.cookies["ecampus"]??'undefined';

      return AuthenticateResponse(true, "", userName, cookie) ;
    }else{
      return AuthenticateResponse(false, "Неверный логин млм пароль");
    }
  }

  Future<http.Response> getMain() async {
    log(jsonEncode(client.headers));
    http.Response response = await client.get('https://ecampus.ncfu.ru/');
    print(response.statusCode);
    log(response.body);
    return response;
  }

  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }
}