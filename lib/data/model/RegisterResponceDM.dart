// import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';
//
// class RegisterResponseDto extends RegisterResponseEntity {
//   @override
//   RegisterResponseDto({
//     super.type,
//     super.errors,
//     super.data,
//     super.statusCode,
//     super.succeeded,
//     super.message,
//   });
//
//   factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
//       RegisterResponseDto(
//         type: json["type"],
//         errors: json["errors"] == null
//             ? []
//             : List<String>.from(json["errors"]!.map((x) => x)),
//         data: json["data"] == null ? null : DataDto.fromJson(json["data"]),
//         statusCode: json["statusCode"],
//         succeeded: json["succeeded"],
//         message: json["message"],
//       );
// }
//
// class DataDto extends DataEntity {
//
//
//   DataDto({
//     super.userId,
//     super.isActivateRequired,
//   });
//
//   factory DataDto.fromJson(Map<String, dynamic> json) => DataDto(
//         userId: json["userId"],
//         isActivateRequired: json["isActivateRequired"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "isActivateRequired": isActivateRequired,
//       };
// }
