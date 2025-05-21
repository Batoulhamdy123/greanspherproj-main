import '../../domain/entities/LoginResponseEntity .dart';

class LoginResponseDto extends LoginResponseEntity {
  LoginResponseDto({
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  LoginResponseDto.fromJson(dynamic json) {
    data = json['data'] != null ? DataLoginDto.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }
}

class DataLoginDto extends DataLoginEntity {
  DataLoginDto({
    super.userId,
    super.isActivateRequired,
  });

  DataLoginDto.fromJson(dynamic json) {
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
