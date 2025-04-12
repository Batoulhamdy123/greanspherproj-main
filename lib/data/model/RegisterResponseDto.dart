import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';

class RegisterResponseDto extends RegisterResponseEntity {
  RegisterResponseDto({
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  RegisterResponseDto.fromJson(dynamic json) {
    data = json['data'] != null ? DataRegisterDto.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }
}

class DataRegisterDto extends DataRegisterEntity {
  DataRegisterDto({
    super.userId,
    super.isActivateRequired,
  });

  DataRegisterDto.fromJson(dynamic json) {
    userId = json['userId'];
    isActivateRequired = json['isActivateRequired'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['isActivateRequired'] = isActivateRequired;
    return map;
  }
}
