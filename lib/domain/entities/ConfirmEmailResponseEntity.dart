class ConfirmEmailResponseEntity {
  String? data;
  String? errors;
  String? statusCode;
  bool? succeeded;
  String? message;

  ConfirmEmailResponseEntity({
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}
