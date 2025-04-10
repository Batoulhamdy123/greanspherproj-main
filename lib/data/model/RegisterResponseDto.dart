import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';

class RegisterResponseDto extends RegisterResponseEntity {
  RegisterResponseDto({
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  RegisterResponseDto.fromJson(dynamic json) {
    data = json['data'] != null ? DataDto.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }
}

class DataDto extends DataEntity {
  DataDto({
    super.userId,
    super.isActivateRequired,
  });

  DataDto.fromJson(dynamic json) {
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
