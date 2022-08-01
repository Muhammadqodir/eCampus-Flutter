class Response{
  bool isSuccess = false;
  String error = "";

  Response(this.isSuccess, this.error);
  
}

class AuthenticateResponse extends Response{
  String userName = "";
  String cookie = "";

  AuthenticateResponse(bool isSuccess, String error, [this.userName = "undefined", this.cookie = "undefined"]) : super(isSuccess, error);
}

