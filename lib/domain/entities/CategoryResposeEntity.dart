class CategoryResponseEntity {
  List<CategoryEntity>? value;
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

class CategoryEntity {
  String? name;
  String? description;
  int? totalProducts;
  String? id;

  CategoryEntity({
    this.name,
    this.description,
    this.totalProducts,
    this.id,
  });
}
