class LoginResponseEntity {
  String? type;
  List<String>? errors;
  DataLoginEntity? data;
  String? statusCode;
  bool? succeeded;
  String? message;

  LoginResponseEntity({
    this.type,
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}

class DataLoginEntity {
  String? userId;
  bool? isActivateRequired;

  DataLoginEntity({
    this.userId,
    this.isActivateRequired,
  });
}
