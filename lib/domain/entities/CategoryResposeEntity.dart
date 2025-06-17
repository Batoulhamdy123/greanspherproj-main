class CategoryResponseEntity {
  List<dynamic>? value;
  bool? isSuccess;
  bool? isFailure;
  String? message;
  dynamic errors;
  String? statusCode;

  CategoryResponseEntity({
    this.value,
    this.isSuccess,
    this.isFailure,
    this.message,
    this.errors,
    this.statusCode,
  });
}
