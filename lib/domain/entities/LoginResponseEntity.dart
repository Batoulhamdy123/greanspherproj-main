class LoginResponseEntity {
  List<String>? errors;

  DataResponseEntity? data;
  String? statusCode;
  bool? succeeded;
  String? message;

  LoginResponseEntity({
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}

class DataResponseEntity {
  String? userName;
  String? email;
  String? token;
  List<String>? roles;
  bool? isAuthenticated;
  String? refreshTokenExpiration;

  DataResponseEntity({
    this.userName,
    this.email,
    this.token,
    this.roles,
    this.isAuthenticated,
    this.refreshTokenExpiration,
  });
}
