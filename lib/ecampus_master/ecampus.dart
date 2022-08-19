import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_master/NetworkService.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class ECampus {
  final JsonEncoder _encoder = const JsonEncoder();
  NetworkService client = NetworkService();
  String login = "";
  String password = "";
  String ecampusToken = "undefined";

  ECampus(this.ecampusToken) {
    client.addCookie(
      "ecampus",
      ecampusToken,
    );
  }

  Future<String> getToken() async {
    http.Response response = await client.get(
      'https://ecampus.ncfu.ru/account/login',
    );
    var doc = parse(response.body);
    return doc
            .querySelector(
              '[name="__RequestVerificationToken"]',
            )!
            .attributes['value'] ??
        "error";
  }

  Future<Uint8List> getCaptcha() async {
    client.clearCookies();
    http.Response response =
        await client.get('https://ecampus.ncfu.ru/Captcha/Captcha');
    print(client.cookies);
    return response.bodyBytes;
  }

  Future<Uint8List> getUserPic() async {
    http.Response response = await client
        .get('https://ecampus.ncfu.ru/account/userpic?w=300&s=459124');
    return response.bodyBytes;
  }

  String getCookies() {
    return _encoder.convert(
      client.cookies,
    );
  }

  Future<AuthenticateResponse> authenticate(
      String username, String password, String captcha) async {
    String token = await getToken();

    Map<String, String> body = {
      '__RequestVerificationToken': token,
      'Login': username,
      'Password': password,
      'Code': captcha,
      'RememberMe': "true",
    };

    print(body);
    client.setContentLength(body.length);
    http.Response response =
        await client.post('https://ecampus.ncfu.ru/Account/Login', body: body);
    if (response.statusCode == 302) {
      http.Response home = await client.get('https://ecampus.ncfu.ru');
      var doc = parse(home.body);

      String userName = doc.getElementsByClassName("username")[0].innerHtml;
      String cookie = client.cookies["ecampus"] ?? 'undefined';

      return AuthenticateResponse(true, "", userName, cookie);
    } else {
      return AuthenticateResponse(
          false, "Неверное имя пользователя или пароль или код проверки");
    }
  }

  Future<http.Response> getMain() async {
    http.Response response = await client.get('https://ecampus.ncfu.ru/');
    print(response.statusCode);
    return response;
  }

  Future<String> getUserName() async {
    http.Response response = await client.get('https://ecampus.ncfu.ru');
    print(getCookies());
    if (response.statusCode == 200) {
      var doc = parse(response.body);
      String userName = doc.getElementsByClassName("username")[0].innerHtml;
      return userName;
    } else {
      return "undefined";
    }
  }

  Future<bool> isActualToken() async {
    http.Response response =
        await client.post("https://ecampus.ncfu.ru/details");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  Future<RatingResponse> getRating() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/rating');

      print(getCookies());
      if (response.statusCode == 200) {
        RatingResponse ratingResponse =
            RatingResponse(false, "data is not filled");
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("academicResults")) {
          List<dynamic> academicResults = jsonObject["academicResults"];
          int size = academicResults.length;
          if (size > 0) {
            Map<String, dynamic> ratingList = academicResults[size - 1];
            if (ratingList.containsKey('Details')) {
              List<dynamic> detalis = ratingList["Details"];
              int detalisSize = detalis.length;
              if (detalisSize > 0) {
                List<RatingModel> models = [];
                for (var element in detalis) {
                  Map<String, dynamic> detailsItem = element;
                  models.add(RatingModel(
                      detailsItem["Name"],
                      double.parse(detailsItem["SumRating"]) * 100,
                      detailsItem["PositionInGroup"],
                      detailsItem["PositionInInstitute"],
                      detalisSize + 1,
                      detailsItem["MaxPositionInInstitute"],
                      detailsItem["IsCurrent"]));
                  if (detailsItem["IsCurrent"]) {
                    ratingResponse.averageRating =
                        double.parse(detailsItem["SumRating"]) * 100;
                    ratingResponse.groupRating = detailsItem["PositionInGroup"];
                    ratingResponse.instituteRating =
                        detailsItem["PositionInInstitute"];
                    ratingResponse.studentsNumberInInstitute =
                        detailsItem["MaxPositionInInstitute"];
                  }
                }
                ratingResponse.items = models;
                ratingResponse.studentsNumberInGroup = models.length + 1;
                ratingResponse.isSuccess = true;
                ratingResponse.error = "";
                return ratingResponse;
              } else {
                ratingResponse.error = "details_size is 0";
                return ratingResponse;
              }
            } else {
              ratingResponse.error = "Response is not contain details";
              return ratingResponse;
            }
          } else {
            ratingResponse.error = "Academic years is empty";
            return ratingResponse;
          }
        } else {
          ratingResponse.error = "Response is not contain Academic results";
          return ratingResponse;
        }
      } else {
        return RatingResponse(false, "Response code${response.statusCode}");
      }
    } catch (e) {
      return RatingResponse(false, e.toString());
    }
  }

  Future<NotificationsResponse> getNotifications() async {
    // try{
    http.Response response = await client.post(
        'https://ecampus.ncfu.ru/NotificationCenter/GetNotificationMessages');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey("Messages")) {
        List<Map<String, dynamic>> messageList =
            List<Map<String, dynamic>>.from(json["Messages"]);
        List<NotificationModel> unread = [];
        List<NotificationModel> read = [];
        messageList.forEach((element) {
          print(element["DateOfReading"]);
          if (element["DateOfReading"] == null) {
            unread.add(NotificationModel(
                title: element["Title"] ?? "undefined",
                message: element["Message"] ?? "undefined",
                dateOfCreation: element["DateOfCreation"] ?? "",
                dateOfReading: "unread",
                actionData: element["ActionData"] ?? "",
                actionType: element["ActionType"] ?? "",
                activityKindColor: element["ActivityKindColor"] ?? "FFB40C",
                activityKindIcon: element["ActivityKindIcon"] ??
                    "/images/icons/education.png",
                activityKindName: element["ActivityKindName"] ?? "undefined",
                categoryId: element["CategoryId"] ?? "",
                notificationImportanceId:
                    element["NotificationImportanceId"] ?? ""));
          } else {
            read.add(NotificationModel(
                title: element["Title"] ?? "undefined",
                message: element["Message"] ?? "undefined",
                dateOfCreation: element["DateOfCreation"] ?? "",
                dateOfReading: element["DateOfReading"] ?? "",
                actionData: element["ActionData"] ?? "",
                actionType: element["ActionType"] ?? "",
                activityKindColor: element["ActivityKindColor"] ?? "FFB40C",
                activityKindIcon: element["ActivityKindIcon"] ??
                    "/images/icons/education.png",
                activityKindName: element["ActivityKindName"] ?? "undefined",
                categoryId: element["CategoryId"] ?? "",
                notificationImportanceId:
                    element["NotificationImportanceId"] ?? ""));
          }
        });
        return NotificationsResponse(true, "error_",
            unread: unread, read: read);
      } else {
        return NotificationsResponse(true, "error_asdf", unread: [], read: []);
      }
    } else {
      return NotificationsResponse(false, "Status code ${response.statusCode}");
    }
    // }catch(e){
    //   return NotificationsResponse(false, e.toString());
    // }
  }
}
