class ResetPasswordResponseEntity {
  List<String>? errors;

  String? data;
  String? statusCode;
  bool? succeeded;
  String? message;

  ResetPasswordResponseEntity({
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}
