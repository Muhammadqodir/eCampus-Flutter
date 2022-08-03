import 'package:ecampus_ncfu/models/rating_model.dart';

class Response {
  bool isSuccess = false;
  String error = "";
  dynamic data;

  Response(this.isSuccess, this.error);
}

class AuthenticateResponse extends Response {
  String userName = "";
  String cookie = "";

  AuthenticateResponse(bool isSuccess, String error,
      [this.userName = "undefined", this.cookie = "undefined"])
      : super(isSuccess, error);
}

class RatingResponse extends Response {
  double averageRating = -1;
  int groupRating = -1;
  int instituteRating = -1;
  int studentsNumberInGroup = -1;
  int studentsNumberInInstitute = -1;
  List<RatingModel> items = [];
  RatingResponse(bool isSuccess, String error,
      [this.averageRating = -1,
      this.groupRating = -1,
      this.instituteRating = -1,
      this.studentsNumberInGroup = -1,
      this.studentsNumberInInstitute = -1,
      this.items = const [],])
      : super(isSuccess, error);

}
