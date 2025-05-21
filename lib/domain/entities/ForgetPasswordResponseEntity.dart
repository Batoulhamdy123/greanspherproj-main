class ForgetPasswordResponseEntity {
  List<String>? errors;

  String? data;
  String? statusCode;
  bool? succeeded;
  String? message;

  ForgetPasswordResponseEntity({
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}
