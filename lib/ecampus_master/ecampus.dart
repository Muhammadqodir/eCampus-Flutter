import 'dart:convert';
import 'dart:developer';
import 'package:ecampus_ncfu/models/record_book_models.dart';
import 'package:html/dom.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_master/NetworkService.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/schedule_models.dart';
import 'package:ecampus_ncfu/models/search_schedule_model.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/models/teacher_model.dart';
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

  void setToken(String ecampusToken) {
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

  Future<String> resetWiFi() async {
    print("test");
    http.Response response = await client
        .post('https://ecampus.ncfu.ru/DomainAccountInfo/GetDomenP');

    print(response.statusCode);
    if (response.statusCode == 200) {
      String passwod = response.body;
      return passwod.replaceAll("\"", "");
    } else {
      return "undefined";
    }
  }

  Future<String> getWifiUserName() async {
    http.Response response =
        await client.get('https://ecampus.ncfu.ru/DomainAccountInfo');

    if (response.statusCode == 200) {
      String body = response.body;
      // print(body);
      var doc = parse(body);

      String userName =
          doc.getElementsByClassName("form-control-static")[0].text;

      return userName;
    } else {
      // print(response.body);
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
                      details_item["Name"].replaceAll("  ", ""),
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
              unread.add(
                NotificationModel(
                    title: element["Title"] ?? "undefined",
                    message: element["Message"] ?? "undefined",
                    dateOfCreation: element["DateOfCreation"] ?? "",
                    dateOfReading: "unread",
                    actionData: element["ActionData"] ?? "",
                    actionType: element["ActionType"] ?? "",
                    messageId: element["MessageId"] ?? -1,
                    activityKindColor: element["ActivityKindColor"] ?? "FFB40C",
                    activityKindIcon: element["ActivityKindIcon"] ??
                        "/images/icons/education.png",
                    activityKindName:
                        element["ActivityKindName"] ?? "undefined",
                    categoryId: element["CategoryId"] ?? -1,
                    notificationImportanceId:
                        element["NotificationImportanceId"] ?? -1),
              );
              log("Messaageid${element["MessageId"] ?? -1}");
              readNotification(element["MessageId"] ?? -1);
            } else {
              read.add(
                NotificationModel(
                    title: element["Title"] ?? "undefined",
                    message: element["Message"] ?? "undefined",
                    dateOfCreation: element["DateOfCreation"] ?? "",
                    dateOfReading: element["DateOfReading"] ?? "",
                    actionData: element["ActionData"] ?? "",
                    messageId: element["MessageId"] ?? -1,
                    actionType: element["ActionType"] ?? "",
                    activityKindColor: element["ActivityKindColor"] ?? "FFB40C",
                    activityKindIcon: element["ActivityKindIcon"] ??
                        "/images/icons/education.png",
                    activityKindName:
                        element["ActivityKindName"] ?? "undefined",
                    categoryId: element["CategoryId"] ?? "",
                    notificationImportanceId:
                        element["NotificationImportanceId"] ?? -1),
              );
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

  void readNotification(messageId) async {
    Map<String, String> body = {'messagesIds[]': messageId.toString()};
    http.Response response = await client
        .post('https://ecampus.ncfu.ru/NotificationCenter/SetMessagesRead', body: body);
  }

  Future<SearchScheduleResponse> searchSchedule(String q) async {
    final String url =
        "https://ecampus.ncfu.ru/schedule/search?q=${Uri.encodeComponent(q)}";
    http.Response response = await client.post(url);
    if (response.statusCode == 200) {
      String responseString = response.body;
      var document = parse(responseString);
      List<SearchScheduleResult> scheduleSearchResults = [];
      var resultsParent = document.getElementById("targets-search-result");
      if (resultsParent != null) {
        var results = resultsParent.querySelectorAll("a[href]");
        for (var res in results) {
          Element element = res;
          if (element.attributes["class"] == "all-result-link") {
            continue;
          }
          String link = element.attributes["href"] ?? "undefined";
          int targetType = 0;
          if (link.contains("teacher")) {
            targetType = 1;
          } else if (link.contains("group")) {
            targetType = 2;
          } else if (link.contains("room")) {
            targetType = 3;
          }
          SearchScheduleResult scheduleSearchResult = SearchScheduleResult(
              element.text.replaceAll("  ", ""),
              "https://ecampus.ncfu.ru$link",
              targetType);
          scheduleSearchResults.add(scheduleSearchResult);
        }
      }
      return SearchScheduleResponse(true, "", models: scheduleSearchResults);
    } else {
      log("response.isSuccessful=false");
      return SearchScheduleResponse(false, "searchSchedule::responseFalse");
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
                  MyTeachersResponse? myTeachersResponse;
                  try {
                    myTeachersResponse = await getMyTeachers();
                    CacheSystem.saveMyTeachers(myTeachersResponse);
                  } catch (e) {}
                  subjectsResponse = getSubjectsByJSON(term,
                      myTeachersResponse: myTeachersResponse);
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

  Future<SubjectsResponse> getSubjects(int studentId, int termId) async {
    try {
      Map<String, String> body = {
        'studentId': studentId.toString(),
        'termId': termId.toString()
      };
      http.Response response = await client
          .post('https://ecampus.ncfu.ru/studies/GetCourses', body: body);

      if (response.statusCode == 200) {
        String json = response.body;
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(response.body);
        if (jsonObject != null) {
          List<dynamic> fileAbleActivities = [];
          List<dynamic> sciFiles = [];
          try {
            fileAbleActivities = jsonObject["fileAbleActivities"];
          } catch (e) {}
          try {
            sciFiles = jsonObject["sciFiles"];
          } catch (e) {}
          List<dynamic> courses = jsonObject["courses"];
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
                currentRating = subject["CurrentRating"].toDouble();
                ;
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
                maxRating = subject["MaxRating"].toDouble();
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
                  if (lessonType_ == 55 ||
                      lessonType_ == 5 ||
                      lessonType_ == 4) {
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
      } else {
        return SubjectsResponse(false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return SubjectsResponse(false, e.toString());
    }
  }

  Future<LessonItemsResponse> getLessonItems(
      int studentId, int lessonTypeId) async {
    try {
      Map<String, String> body = {
        'studentId': studentId.toString(),
        'lessonTypeId': lessonTypeId.toString()
      };
      http.Response response = await client
          .post('https://ecampus.ncfu.ru/studies/GetLessons', body: body);

      if (response.statusCode == 200) {
        String json = response.body;
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        List<dynamic>? lessonItems = jsonDecode(response.body);
        if (lessonItems != null) {
          int size = lessonItems.length;
          if (size > 0) {
            List<LessonItemModel> items_arr = [];
            for (int i = 0; i < size; i++) {
              Map<String, dynamic> lessonItem = lessonItems[i];

              int attendance = 0, id = 0, kodPr = 0, loadId = 0;
              double gainedScore = 0, grade = 0, lostScore = 0;
              String name = "", room = "", date = "", gradeText = "";
              bool isCheckpoint = false, hasFile = false;
              try {
                attendance = lessonItem["Attendance"];
              } catch (e) {}
              try {
                gainedScore = lessonItem["GainedScore"];
              } catch (e) {}
              try {
                grade = lessonItem["Grade"];
              } catch (e) {}
              try {
                id = lessonItem["Id"];
              } catch (e) {}
              try {
                kodPr = lessonItem["Kod_pr"];
              } catch (e) {}
              try {
                loadId = lessonItem["LoadId"];
              } catch (e) {}
              try {
                lostScore = lessonItem["LostScore"];
              } catch (e) {}

              try {
                name = lessonItem["Name"];
              } catch (e) {}
              try {
                room = lessonItem["Room"];
              } catch (e) {}
              try {
                date = lessonItem["Date"];
              } catch (e) {}
              try {
                gradeText = lessonItem["GradeText"];
              } catch (e) {}

              try {
                isCheckpoint = lessonItem["IsCheckpoint"];
              } catch (e) {}
              try {
                hasFile = lessonItem["HasFile"];
              } catch (e) {}
              items_arr.add(LessonItemModel(
                  id: id,
                  attendance: attendance,
                  gainedScore: gainedScore,
                  grade: grade,
                  kodPr: kodPr,
                  loadId: loadId,
                  lostScore: lostScore,
                  subject: "",
                  name: name,
                  room: room,
                  date: date,
                  gradeText: gradeText,
                  isCheckpoint: isCheckpoint,
                  hasFile: hasFile));
            }
            return LessonItemsResponse(true, "", models: items_arr);
          } else {
            return LessonItemsResponse(false, "empty list of lessons");
          }
        } else {
          return LessonItemsResponse(false, "json is null");
        }
      } else {
        return LessonItemsResponse(false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return LessonItemsResponse(false, e.toString());
    }
  }

  Future<List<LessonItemsResponse>> getAllLessonItems(
      int studentId, List<LessonTypesModel> types) async {
    List<LessonItemsResponse> models = [];
    for (var element in types) {
      LessonItemsResponse lessonItems =
          await getLessonItems(studentId, element.id);
      models.add(lessonItems);
    }
    return models;
  }

  SubjectsResponse getSubjectsByJSON(Map<String, dynamic> jsonObject,
      {MyTeachersResponse? myTeachersResponse}) {
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
            String teacher = "";
            int teacherId = 0;
            int paretId = 0;
            bool locked = false;
            int id = 0;
            String termsForAtt = "";
            try {
              termsForAtt = subject["termsForAtt"];
            } catch (e) {}
            try {
              currentRating = subject["CurrentRating"].toDouble();
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
              maxRating = subject["MaxRating"].toDouble();
            } catch (e) {}
            try {
              name = subject["Name"];
              log(name);
            } catch (e) {}
            try {
              if (myTeachersResponse != null) {
                for (TeacherModel teach in myTeachersResponse.teachers) {
                  if (teach.subjects.contains(name)) {
                    teacher = teach.fullName;
                    teacherId = teach.id;
                  }
                }
              }
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
                teacherId: teacherId,
                teacherName: teacher,
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

  Future<ScheduleWeeksResponse> getScheduleWeeks() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/schedule/my/student');
      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("weeks")) {
          int size = jsonObject["weeks"].length;
          if (size > 0) {
            List<ScheduleWeeksModel> scheduleWeeks = [];
            for (var i = 0; i < size; i++) {
              Map<String, dynamic> weekday = jsonObject["weeks"][i];
              String weekType = "";
              String dateBegin = "";
              String dateEnd = "";
              String number = "";
              try {
                weekType = weekday["WeekType"];
              } catch (e) {}
              try {
                dateBegin = weekday["DateBegin"];
              } catch (e) {}
              try {
                dateEnd = weekday["DateEnd"];
              } catch (e) {}
              try {
                number = weekday["Number"].toString();
              } catch (e) {}

              scheduleWeeks.add(
                ScheduleWeeksModel(
                  weekType: weekType,
                  dateBegin: dateBegin,
                  dateEnd: dateEnd,
                  number: number,
                ),
              );
            }

            int id = 0;
            int type = 0;
            int current = 0;
            try {
              current = jsonObject["currentWeekIndex"];
            } catch (e) {}
            try {
              type = jsonObject["Model"]["Type"];
            } catch (e) {}
            try {
              id = jsonObject["Model"]["Id"];
            } catch (e) {}
            return ScheduleWeeksResponse(true, "",
                id: id, type: type, currentWeek: current, weeks: scheduleWeeks);
          } else {
            return ScheduleWeeksResponse(false, "weeks array is empty");
          }
        } else {
          return ScheduleWeeksResponse(false, "specialities is empty");
        }
      } else {
        return ScheduleWeeksResponse(
            false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return ScheduleWeeksResponse(false, e.toString());
    }
  }

  Future<ScheduleWeeksResponse> getScheduleWeeksFromUrl(String url) async {
    try {
      http.Response response = await client.post(url);
      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("weeks")) {
          int size = jsonObject["weeks"].length;
          if (size > 0) {
            List<ScheduleWeeksModel> scheduleWeeks = [];
            for (var i = 0; i < size; i++) {
              Map<String, dynamic> weekday = jsonObject["weeks"][i];
              String weekType = "";
              String dateBegin = "";
              String dateEnd = "";
              String number = "";
              try {
                weekType = weekday["WeekType"];
              } catch (e) {}
              try {
                dateBegin = weekday["DateBegin"];
              } catch (e) {}
              try {
                dateEnd = weekday["DateEnd"];
              } catch (e) {}
              try {
                number = weekday["Number"].toString();
              } catch (e) {}

              scheduleWeeks.add(
                ScheduleWeeksModel(
                  weekType: weekType,
                  dateBegin: dateBegin,
                  dateEnd: dateEnd,
                  number: number,
                ),
              );
            }

            int id = 0;
            int type = 0;
            int current = 0;
            try {
              current = jsonObject["currentWeekIndex"];
            } catch (e) {}
            try {
              type = jsonObject["Model"]["Type"];
            } catch (e) {}
            try {
              id = jsonObject["Model"]["Id"];
            } catch (e) {}
            return ScheduleWeeksResponse(true, "",
                id: id, type: type, currentWeek: current, weeks: scheduleWeeks);
          } else {
            return ScheduleWeeksResponse(false, "weeks array is empty");
          }
        } else {
          return ScheduleWeeksResponse(false, "specialities is empty");
        }
      } else {
        return ScheduleWeeksResponse(
            false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return ScheduleWeeksResponse(false, e.toString());
    }
  }

  Future<MyTeachersResponse> getMyTeachers() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/schedule/my/student');
      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("weeks")) {
          int size = jsonObject["weeks"].length;
          if (size > 0) {
            List<ScheduleWeeksModel> scheduleWeeks = [];
            for (var i = 0; i < size; i++) {
              Map<String, dynamic> weekday = jsonObject["weeks"][i];
              String weekType = "";
              String dateBegin = "";
              String dateEnd = "";
              String number = "";
              try {
                weekType = weekday["WeekType"];
              } catch (e) {}
              try {
                dateBegin = weekday["DateBegin"];
              } catch (e) {}
              try {
                dateEnd = weekday["DateEnd"];
              } catch (e) {}
              try {
                number = weekday["Number"].toString();
              } catch (e) {}

              scheduleWeeks.add(
                ScheduleWeeksModel(
                  weekType: weekType,
                  dateBegin: dateBegin,
                  dateEnd: dateEnd,
                  number: number,
                ),
              );
            }

            int id = 0;
            int type = 0;
            int current = 0;
            try {
              current = jsonObject["currentWeekIndex"];
            } catch (e) {}
            try {
              type = jsonObject["Model"]["Type"];
            } catch (e) {}
            try {
              id = jsonObject["Model"]["Id"];
            } catch (e) {}
            //Creating list of teachers
            List<TeacherModel> teacherModels = [];
            int secondWeek = ((current == 0) ? current + 1 : current - 1);
            var weeks = {current, secondWeek};
            String tIDs = "";
            for (int i in weeks) {
              log("Size: ${scheduleWeeks.length}");
              ScheduleResponse scheduleResponse =
                  await getSchedule(scheduleWeeks[i].dateBegin, id, type);
              //test
              if (scheduleResponse.isSuccess) {
                List<ScheduleModel> scheduleModels =
                    scheduleResponse.scheduleModels;
                for (ScheduleModel scheduleModel in scheduleModels) {
                  for (ScheduleLessonsModel lessonsModel
                      in scheduleModel.lessons) {
                    if (!tIDs.contains(lessonsModel.teacherId.toString())) {
                      TeacherModel teacherModel = TeacherModel(
                          lessonsModel.teacherId, lessonsModel.teacher, []);
                      teacherModel.addSubject(lessonsModel.subName);
                      teacherModels.add(teacherModel);
                      tIDs += "${teacherModel.id}-${lessonsModel.subName} ";
                    } else {
                      if (!tIDs.contains(
                          "${lessonsModel.teacherId}-${lessonsModel.subName}")) {
                        for (int j = 0; j < teacherModels.length; j++) {
                          if (teacherModels[j].id == lessonsModel.teacherId) {
                            teacherModels[j].addSubject(lessonsModel.subName);
                            tIDs +=
                                "${lessonsModel.teacherId}-${lessonsModel.subName} ";
                            break;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            return MyTeachersResponse(true, "", teachers: teacherModels);
          } else {
            return MyTeachersResponse(false, "weeks array is empty");
          }
        } else {
          return MyTeachersResponse(false, "specialities is empty");
        }
      } else {
        return MyTeachersResponse(false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return MyTeachersResponse(false, e.toString());
    }
  }

  Future<ScheduleResponse> getSchedule(
      String dateFrom, int id, int type) async {
    try {
      Map<String, String> body = {
        'date': dateFrom,
        'Id': id.toString(),
        'targetType': type.toString()
      };
      http.Response response = await client
          .post('https://ecampus.ncfu.ru/Schedule/GetSchedule', body: body);

      if (response.statusCode == 200) {
        String json = response.body;

        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        List<dynamic> jsonObject = jsonDecode(json);
        int size = jsonObject.length;
        if (size > 0) {
          List<ScheduleModel> scheduleModels = [];
          for (var i = 0; i < size; i++) {
            Map<String, dynamic> weekday = jsonObject[i];
            String weekday_ = weekday["WeekDay"];
            DateTime date = DateTime.parse(weekday["Date"]);
            ScheduleModel model = ScheduleModel(
              weekDay: weekday_,
              date: date,
              lessons: [],
            );
            List<dynamic> lessons = weekday["Lessons"];
            List<ScheduleLessonsModel> lessoonsModels = [];
            for (int j = 0; j < lessons.length; j++) {
              Map<String, dynamic> lesson = lessons[j];
              String subName = "";
              DateTime timeStart = DateTime.now();
              DateTime timeEnd = DateTime.now();
              String room = "";
              int roomId = -1;
              String teacher = "";
              int teacherId = -1;
              bool current = false;
              int para = -1;
              String lessonType = "";
              try {
                subName = lesson["Discipline"];
              } catch (e) {}
              try {
                timeStart = DateTime.parse(lesson["TimeBegin"]);
                timeEnd = DateTime.parse(lesson["TimeEnd"]);
              } catch (e) {}
              try {
                room = lesson["Aud"]["Name"];
                roomId = lesson["Aud"].getInt["Id"];
              } catch (e) {}
              try {
                teacher = lesson["Teacher"]["Name"];
                teacherId = lesson["Teacher"]["Id"];
              } catch (e) {}
              String group = "";
              try {
                para = lesson["PairNumberStart"];
              } catch (e) {}
              try {
                current = lesson["Current"];
              } catch (e) {}
              try {
                int gr_size = lesson["Groups"].length;
                for (int k = 0; k < gr_size; k++) {
                  group += lesson["Groups"][k]["Name"] +
                      lesson["Groups"][k]["Subgroup"];
                }
              } catch (e) {}
              try {
                lessonType = lesson["LessonType"];
              } catch (e) {}
              lessoonsModels.add(
                ScheduleLessonsModel(
                  current: current,
                  subName: subName,
                  room: room,
                  roomId: roomId,
                  timeEnd: timeEnd,
                  timeStart: timeStart,
                  lessonType: lessonType,
                  group: group,
                  teacher: teacher,
                  teacherId: teacherId,
                  para: para,
                ),
              );
            }

            model.lessons = lessoonsModels;
            scheduleModels.add(model);
          }
          return ScheduleResponse(true, "", scheduleModels: scheduleModels);
        } else {
          return ScheduleResponse(false, "getSchedule response is empty");
        }
      } else {
        return ScheduleResponse(false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return ScheduleResponse(false, e.toString());
    }
  }

  Future<ScheduleResponse> getCurrentSchedule() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/schedule/my/student');

      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        List<dynamic> jsonObject = jsonDecode(json)["weekdays"];

        int size = jsonObject.length;
        if (size > 0) {
          List<ScheduleModel> scheduleModels = [];
          for (var i = 0; i < size; i++) {
            Map<String, dynamic> weekday = jsonObject[i];
            String weekday_ = weekday["WeekDay"];
            DateTime date = DateTime.parse(weekday["Date"]);
            ScheduleModel model = ScheduleModel(
              weekDay: weekday_,
              date: date,
              lessons: [],
            );
            List<dynamic> lessons = weekday["Lessons"];
            log(weekday_);
            List<ScheduleLessonsModel> lessoonsModels = [];
            for (int j = 0; j < lessons.length; j++) {
              Map<String, dynamic> lesson = lessons[j];
              String subName = "";
              DateTime timeStart = DateTime.now();
              DateTime timeEnd = DateTime.now();
              String room = "";
              int roomId = -1;
              String teacher = "";
              int teacherId = -1;
              bool current = false;
              int para = -1;
              String lessonType = "";
              try {
                subName = lesson["Discipline"];
              } catch (e) {}
              try {
                timeStart = DateTime.parse(lesson["TimeBegin"]);
                timeEnd = DateTime.parse(lesson["TimeEnd"]);
              } catch (e) {}
              try {
                room = lesson["Aud"]["Name"];
                roomId = lesson["Aud"].getInt["Id"];
              } catch (e) {}
              try {
                teacher = lesson["Teacher"]["Name"];
                teacherId = lesson["Teacher"]["Id"];
              } catch (e) {}
              String group = "";
              try {
                para = lesson["PairNumberStart"];
              } catch (e) {}
              try {
                current = lesson["Current"];
              } catch (e) {}
              try {
                int gr_size = lesson["Groups"].length;
                for (int k = 0; k < gr_size; k++) {
                  group += lesson["Groups"][k]["Name"] +
                      lesson["Groups"][k]["Subgroup"];
                }
              } catch (e) {}
              try {
                lessonType = lesson["LessonType"];
              } catch (e) {}
              log(subName);
              lessoonsModels.add(
                ScheduleLessonsModel(
                  current: current,
                  subName: subName,
                  room: room,
                  roomId: roomId,
                  timeEnd: timeEnd,
                  timeStart: timeStart,
                  lessonType: lessonType,
                  group: group,
                  teacher: teacher,
                  teacherId: teacherId,
                  para: para,
                ),
              );
            }

            model.lessons = lessoonsModels;
            scheduleModels.add(model);
          }
          return ScheduleResponse(true, "", scheduleModels: scheduleModels);
        } else {
          return ScheduleResponse(false, "getSchedule response is empty");
        }
      } else {
        return ScheduleResponse(false, "Status code ${response.statusCode}");
      }
    } catch (e) {
      return ScheduleResponse(false, e.toString());
    }
  }

  Future<RecordBookResponse> getRecordBook() async {
    try {
      http.Response response =
          await client.post('https://ecampus.ncfu.ru/details/zachetka');

      if (response.statusCode == 200) {
        String responseString = response.body;
        int start = responseString.indexOf("var viewModel = ") + 16;
        String json = responseString.substring(start);
        start = json.indexOf("</script>") - 3;
        json = json.substring(0, start);
        json = json.replaceAll("JSON.parse(\"\\\"", "\"");
        json = json.replaceAll("\\\"\")", "\"");
        Map<String, dynamic> jsonObject = jsonDecode(json);
        if (jsonObject.containsKey("EducationDetails")) {
          List<dynamic> educationDetails = jsonObject["EducationDetails"];
          Map<String, dynamic> educationDetail =
              educationDetails[educationDetails.length - 1];
          List<dynamic> studyYears = educationDetail["StudyYears"];
          List<RecordBookCourseModel> courseModels = [];
          for (int i = 0; i < studyYears.length; i++) {
            Map<String, dynamic> studyYear = studyYears[i];
            String title = studyYear["Name"];
            log(title);
            List<dynamic> terms = studyYear["Terms"];
            List<RecordBookTermModel> termModels = [];
            for (int j = 0; j < terms.length; j++) {
              Map<String, dynamic> term = terms[j];
              String termTitle = term["Name"];
              log(termTitle);
              List<RecordBookItem> recordBookItems = [];
              List<String> listIndexes = ["Exams", "Zachets", "Other"];
              for (int k = 0; k < listIndexes.length; k++) {
                List<dynamic> list = term[listIndexes[k]];
                for (int d = 0; d < list.length; d++) {
                  Map<String, dynamic> li = list[d];
                  String disc = li["Discipline"] ?? "".replaceAll("  ", " ");
                  String hours = li["Hours"].toString();
                  String type = li["Kod_v_name"] ?? "".replaceAll("  ", " ");
                  String mark = li["Mark"] ?? "".replaceAll(" ", "");
                  String teacher = li["Teacher"] ?? "".replaceAll("  ", " ");
                  String date = li["Date"].replaceAll("  ", " ");
                  RecordBookItem item = RecordBookItem(
                      disc, hours, mark, date, teacher, type, false);
                  recordBookItems.add(item);
                }
              }
              termModels.add(RecordBookTermModel(termTitle, recordBookItems));
            }
            RecordBookCourseModel courseModel =
                RecordBookCourseModel(title, termModels);
            courseModels.add(courseModel);
          }
          return RecordBookResponse(true, "", models: courseModels);
        } else {
          return RecordBookResponse(true, "EducationDetails not has json",
              models: []);
        }
      } else {
        return RecordBookResponse(false, "response.isSuccessful=false",
            models: []);
      }
    } catch (e) {
      return RecordBookResponse(false, e.toString(), models: []);
    }
  }

  Future<int> getNotificationSize() async {
    // try {
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
        return unread.length;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
    // } catch (e) {
    //   return RecordBookResponse(false, e.toString(), []);
    // }
  }
}
