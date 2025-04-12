class RegisterResponseEntity {
  String? type;
  List<String>? errors;
  DataRegisterEntity? data;
  String? statusCode;
  bool? succeeded;
  String? message;

  RegisterResponseEntity({
    this.type,
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}

class DataRegisterEntity {
  String? userId;
  bool? isActivateRequired;

  DataRegisterEntity({
    this.userId,
    this.isActivateRequired,
  });
}
