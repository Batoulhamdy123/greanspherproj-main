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
    value = List<dynamic>.from(json["value"].map((x) => x));
    isSuccess = json["isSuccess"];
    isFailure = json["isFailure"];
    message = json["message"];
    errors = json["errors"];
    statusCode = json["statusCode"];
  }
}
