import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';

class CategoryResponseDto extends CategoryResponseEntity {
  CategoryResponseDto({
    super.value,
    super.isSuccess,
    super.isFailure,
    super.message,
    super.errors,
    super.statusCode,
  });

  CategoryResponseDto.fromJson(Map<String, dynamic> json) {
    value = List.from(json["value"].map((x) => x));
    isSuccess = json["isSuccess"];
    isFailure = json["isFailure"];
    message = json["message"];
    errors = json["errors"];
    statusCode = json["statusCode"];
  }
}

class CategoryEntityDto extends CategoryEntity {
  CategoryEntityDto({
    super.name,
    super.description,
    super.totalProducts,
    super.id,
  });

  factory CategoryEntityDto.fromJson(Map<String, dynamic> json) =>
      CategoryEntityDto(
        name: json["name"],
        description: json["description"],
        totalProducts: json["totalProducts"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "totalProducts": totalProducts,
        "id": id,
      };
}
