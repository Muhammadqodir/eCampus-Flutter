import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ecampus_ncfu/ecampus_master.dart/NetworkService.dart';
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

  Future<String> authenticate(String username, String password, String captcha) async {
    String token = await getToken();
    
    http.Response response = await http.get(Uri.parse('https://ecampus.ncfu.ru/Captcha/Captcha'));
    
    print(response.statusCode);
    print(response.bodyBytes);
    return "ok";
  }

}