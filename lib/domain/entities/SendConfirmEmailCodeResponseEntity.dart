class SendConfirmEmailCodeResponseEntity {
  SendConfirmEmailCodeDataEntity? data;
  List<String>? errors;

  String? statusCode;
  bool? succeeded;
  String? message;

  SendConfirmEmailCodeResponseEntity({
    this.errors,
    this.data,
    this.statusCode,
    this.succeeded,
    this.message,
  });
}

class SendConfirmEmailCodeDataEntity {
  String? codeExpiration;

  SendConfirmEmailCodeDataEntity({
    this.codeExpiration,
  });
}
