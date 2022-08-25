import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_master/NetworkService.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class eCampus {
  final JsonEncoder _encoder = const JsonEncoder();
  NetworkService client = new NetworkService();
  String login = "";
  String password = "";
  String ecampusToken = "undefined";

  eCampus(String ecampusToken) {
    this.ecampusToken = ecampusToken;
    client.addCookie("ecampus", ecampusToken);
  }

  Future<String> getToken() async {
    http.Response response =
        await client.get('https://ecampus.ncfu.ru/account/login');
    var doc = parse(response.body);
    return doc
            .querySelector('[name="__RequestVerificationToken"]')!
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
    return _encoder.convert(client.cookies);
  }

  Future<AuthenticateResponse> authenticate(
      String username, String password, String captcha) async {
    String token = await getToken();

    Map<String, String> body = {
      '__RequestVerificationToken': token,
      'Login': username,
      'Password': password,
      'Code': captcha,
      'RememberMe': "true"
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
      return userName.replaceAll("  ", "");
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
    } catch (_) {
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
              int detalis_size = detalis.length;
              if (detalis_size > 0) {
                List<RatingModel> models = [];
                detalis.forEach((element) {
                  Map<String, dynamic> details_item = element;
                  models.add(RatingModel(
                      details_item["Name"],
                      double.parse(details_item["SumRating"]) * 100,
                      details_item["PositionInGroup"],
                      details_item["PositionInInstitute"],
                      detalis_size + 1,
                      details_item["MaxPositionInInstitute"],
                      details_item["IsCurrent"]));
                  if (details_item["IsCurrent"]) {
                    ratingResponse.averageRating =
                        double.parse(details_item["SumRating"]) * 100;
                    ratingResponse.groupRating =
                        details_item["PositionInGroup"];
                    ratingResponse.instituteRating =
                        details_item["PositionInInstitute"];
                    ratingResponse.studentsNumberInInstitute =
                        details_item["MaxPositionInInstitute"];
                  }
                });
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
    try {
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
          return NotificationsResponse(true, "error_asdf",
              unread: [], read: []);
        }
      } else {
        return NotificationsResponse(
            false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return NotificationsResponse(false, e.toString());
    }
  }

  Future<AcademicYearsResponse> getAcademicYears() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/studies');
      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("specialities")) {
          SubjectsResponse subjectsResponse = SubjectsResponse.buildDefault();
          int Kod_cart = 0;
          int portionSize = 0;
          int studentId = 0;
          try {
            Kod_cart = jsonObject["Kod_cart"];
          } catch (e) {}
          try {
            portionSize = jsonObject["portionSize"];
          } catch (e) {}

          List<dynamic> specialities = jsonObject["specialities"];
          int size = specialities.length;

          Map<String, dynamic> lastSpecialitie = specialities[size - 1];
          List<dynamic> academicYears = lastSpecialitie["AcademicYears"];

          try {
            studentId = lastSpecialitie["Id"];
          } catch (e) {}

          List<AcademicYearsModel> models = [];
          for (var i = 0; i < academicYears.length; i++) {
            Map<String, dynamic> academicYear = academicYears[i];
            String kursName = "";
            String kursTypeName = "";
            String name = "";
            int id = 0;
            int parent_id = 0;
            try {
              kursName = academicYear["KursTypeName"];
            } catch (e) {}
            try {
              name = academicYear["Name"];
            } catch (e) {}
            try {
              parent_id = academicYear["ParentId"];
            } catch (e) {}
            try {
              id = academicYear["Id"];
            } catch (e) {}
            log(name);

            AcademicYearsModel model =
                AcademicYearsModel(kursName, name, id, parent_id, false, []);
            List<TermModel> termModels = [];
            List<dynamic> terms = academicYear["Terms"];
            for (var j = 0; j < terms.length; j++) {
              Map<String, dynamic> term = terms[j];
              bool isCurrent = false;
              String TermTypeName = "";
              String term_Name = "";
              int term_id = 0;
              int term_parent_id = 0;
              try {
                term_parent_id = term["ParentId"];
              } catch (e) {}
              try {
                term_id = term["Id"];
              } catch (e) {}
              try {
                term_Name = term["Name"];
              } catch (e) {}
              try {
                TermTypeName = term["TermTypeName"];
              } catch (e) {}
              try {
                isCurrent = term["IsCurrent"];
                if (isCurrent) {
                  subjectsResponse = getSubjectsByJSON(term);
                }
              } catch (e) {}
              if (isCurrent) {
                model.isCurrent = true;
              }

              TermModel termModel = TermModel(
                  isCurrent, TermTypeName, term_Name, term_parent_id, term_id);
              termModels.add(termModel);
            }

            model.termModels = termModels;
            models.add(model);
          }
          return AcademicYearsResponse(true, "",
              models: models,
              kodCart: Kod_cart,
              portionSize: portionSize,
              studentId: studentId,
              currentSubjects: subjectsResponse);
        } else {
          return AcademicYearsResponse(false, "specialities is empty");
        }
      } else {
        return AcademicYearsResponse(
            false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return AcademicYearsResponse(false, e.toString());
    }
  }

  SubjectsResponse getSubjectsByJSON(Map<String, dynamic> jsonObject) {
    try {
      if (jsonObject != null) {
        List<dynamic> fileAbleActivities = [];
        List<dynamic> sciFiles = [];
        try {
          fileAbleActivities = jsonObject["FileAbleActivities"];
        } catch (e) {}
        try {
          sciFiles = jsonObject["SciFiles"];
        } catch (e) {}
        List<dynamic> courses = jsonObject["Courses"];
        int size = courses.length;
        if (size > 0) {
          List<SubjectModel> subjectModels = [];
          for (int i = 0; i < size; i++) {
            Map<String, dynamic> subject = courses[i];
            double currentRating = 0;
            bool hasInstruction = false;
            bool hasLectures = false;
            bool HasUMK = false;
            bool isConfirmDocumentExists = false;
            double maxRating = 0;
            String name = "";
            int paretId = 0;
            bool locked = false;
            int id = 0;
            String termsForAtt = "";
            try {
              termsForAtt = subject["termsForAtt"];
            } catch (e) {}
            try {
              currentRating = subject["CurrentRating"];
            } catch (e) {}
            try {
              hasInstruction = subject["HasInstruction"];
            } catch (e) {}
            try {
              hasLectures = subject["HasLectures"];
            } catch (e) {}
            try {
              HasUMK = subject["HasUMK"];
            } catch (e) {}
            try {
              isConfirmDocumentExists = subject["IsConfirmDocumentExists"];
            } catch (e) {}
            try {
              locked = subject["locked"];
            } catch (e) {}
            try {
              maxRating = subject["MaxRating"];
            } catch (e) {}
            try {
              name = subject["Name"];
              log(name);
            } catch (e) {}
            try {
              paretId = subject["ParentId"];
            } catch (e) {}
            try {
              id = subject["Id"];
            } catch (e) {}
            List<dynamic> lessonTypes = [];
            try {
              lessonTypes = subject["LessonTypes"];
            } catch (e) {}
            String subType = "";
            List<LessonTypesModel> lessonTypesArrayList = [];
            for (int j = 0; j < lessonTypes.length; j++) {
              Map<String, dynamic> lessonTypeObject = lessonTypes[j];
              int typeId = 0;
              int kodPr = 0;
              int lessonType_ = 0;
              String typeName = "";
              int typeParentId = 0;
              bool schoolType = false;
              try {
                typeId = lessonTypeObject["Id"];
              } catch (e) {}
              try {
                kodPr = lessonTypeObject["Kod_pr"];
              } catch (e) {}
              try {
                lessonType_ = lessonTypeObject["LessonType"];
              } catch (e) {}
              try {
                typeName = lessonTypeObject["Name"];
                if (lessonType_ == 55 || lessonType_ == 5 || lessonType_ == 4) {
                  subType = typeName;
                }
              } catch (e) {}
              try {
                typeParentId = lessonTypeObject["ParentId"];
              } catch (e) {}
              try {
                schoolType = lessonTypeObject["SchoolType"];
              } catch (e) {}
              lessonTypesArrayList.add(
                LessonTypesModel(
                  id: typeId,
                  parentId: typeParentId,
                  kodPr: kodPr,
                  lessonType: lessonType_,
                  name: typeName,
                  schoolType: schoolType,
                ),
              );
            }
            subjectModels.add(
              SubjectModel(
                id: id,
                parentId: paretId,
                name: name,
                termsForAtt: termsForAtt,
                subType: subType,
                currentRating: currentRating,
                maxRating: maxRating,
                locked: locked,
                lessonTypes: lessonTypesArrayList,
                hasInstruction: hasLectures,
                hasLectures: hasLectures,
                hasUMK: HasUMK,
                isConfirmDocumentExists: isConfirmDocumentExists,
              ),
            );
          }
          return SubjectsResponse(
            true,
            "",
            fileAbleActivities: fileAbleActivities,
            sciFiles: sciFiles,
            models: subjectModels,
          );
        } else {
          return SubjectsResponse(false, "Subjects is Null");
        }
      } else {
        return SubjectsResponse(false, "json is null");
      }
    } catch (e) {
      return SubjectsResponse(false, e.toString());
    }
  }
}
