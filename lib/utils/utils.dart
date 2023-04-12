import 'dart:developer';

import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';

double getWidthPercent(BuildContext context, int percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeightPercent(BuildContext context, int percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}

RatingModel getMyRating(List<RatingModel> models) {
  RatingModel model = RatingModel("undefined", -1, -1, -1, -1, -1, true);
  models.forEach((element) {
    if (element.isCurrent) {
      model = element;
    }
  });
  return model;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('ecampus.ncfu.ru');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }else{
      return false;
    }
  } on SocketException catch (error) {
    log(error.toString());
    return false;
  }
}

String getCurrentDateTime(){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDate = dateFormat.format(DateTime.now());
    return currentDate;
}

String getCurrentDateTimeForReview(){
    DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm");
    String currentDate = dateFormat.format(DateTime.now());
    return currentDate;
}