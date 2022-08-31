import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentCache {
  String userName = "undefined";
  Uint8List? userPic;
  RatingModel ratingModel = RatingModel("undefined", -1, -1, -1, -1, -1, true);
  StudentCache(this.userName, this.userPic, this.ratingModel);
}

class CacheSystem {
  static var prefix = "cache_";

  static void saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("${prefix}userName", userName);
  }

  static void saveUserPic(Uint8List userPic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("${prefix}userPic", base64Encode(userPic.toList()));
  }

  static void saveRating(RatingModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("${prefix}rating", jsonEncode(data.toJson()));
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDate = dateFormat.format(DateTime.now());
    await prefs.setString("${prefix}date", currentDate);
  }

  static Future<bool> isActualCache() async {
    final prefs = await SharedPreferences.getInstance();
    String cacheDateStr =
        prefs.getString("${prefix}date") ?? "2001-08-06 10:45:00";
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime cacheDate = dateFormat.parse(cacheDateStr);
    DateTime dateNow = DateTime.now();
    if (dateNow.subtract(const Duration(minutes: 1)).isAfter(cacheDate)) {
      return false;
    }
    return true;
  }

  static void saveStudentCache(StudentCache cache) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('${prefix}userName', cache.userName);
    if (cache.userPic != null) {
      await prefs.setString(
          '${prefix}userPic', base64Encode(cache.userPic!.toList()));
    }
    await prefs.setString(
        "${prefix}rating", jsonEncode(cache.ratingModel.toJson()));
  }

  static Future<StudentCache> getStudentCache() async {
    final prefs = await SharedPreferences.getInstance();
    String userPic = prefs.getString("${prefix}userPic") ?? "empty";
    Uint8List? pic;
    if (userPic != "empty") {
      pic = base64Decode(userPic);
    } else {
      pic = null;
    }
    String ratingStr = prefs.getString("${prefix}rating") ?? "empty";
    RatingModel ratingModel =
        RatingModel("undefined", -1, -1, -1, -1, -1, true);
    if (ratingStr != "empty") {
      Map<String, dynamic> rating = jsonDecode(ratingStr);
      ratingModel.fullName = rating["fullName"];
      ratingModel.ratGroup = rating["ratGroup"];
      ratingModel.ratInst = rating["ratInst"];
      ratingModel.maxPosGroup = rating["maxPosGroup"];
      ratingModel.maxPosInst = rating["maxPosInst"];
      ratingModel.isCurrent = rating["isCurrent"];
      ratingModel.ball = rating["ball"];
    }

    return StudentCache(
        prefs.getString("${prefix}userName") ?? "undefined", pic, ratingModel);
  }

  static void invalidateStudentCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("${prefix}userName", "undefined");
    await prefs.setString("${prefix}userPic", "empty");
    await prefs.setString("${prefix}rating", "empty");
    await prefs.setString("${prefix}date", "2001-08-06 10:45:00");
  }

  static void saveAcademicYearsResponse(AcademicYearsResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${prefix}AcademicYearsResponse', jsonEncode(response.toJson()));
    await prefs.setString(
        '${prefix}AcademicYearsResponse_time', getCurrentDateTime());
  }

  static Future<CacheResult?> getAcademicYearsResponse() async {
    final prefs = await SharedPreferences.getInstance();
    String date = prefs.getString('${prefix}AcademicYearsResponse_time') ??
        "2001-08-06 10:45:00";
    String dataStr =
        prefs.getString('${prefix}AcademicYearsResponse') ?? "empty";
    if (dataStr != "empty") {
      Map<String, dynamic> data = jsonDecode(dataStr);
      return CacheResult(date, AcademicYearsResponse.fromJson(data));
    } else {
      return null;
    }
  }
}

class CacheResult{
  String date = "2001-08-06 10:45:00";
  dynamic value;

  CacheResult(this.date, this.value);

  DateTime getDate(){
    return DateTime.parse(date);
  }
}