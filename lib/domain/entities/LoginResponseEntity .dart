class LoginResponseEntity {
  String? type;
  List<String>? errors;
  DataEntity? data;
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

class DataEntity {
  String? userId;
  bool? isActivateRequired;

  DataEntity({
    this.userId,
    this.isActivateRequired,
  });
}
