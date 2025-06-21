import 'package:greanspherproj/domain/entities/LoginResponseEntity.dart';

class LoginResponseDto extends LoginResponseEntity {
  LoginResponseDto({
    super.errors,
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  LoginResponseDto.fromJson(dynamic json) {
    data = json['data'] != null ? DataResponseDto.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }
}

class DataResponseDto extends DataResponseEntity {
  DataResponseDto({
    super.userName,
    super.email,
    super.token,
    super.roles,
    super.isAuthenticated,
    super.refreshTokenExpiration,
  });

  DataResponseDto.fromJson(dynamic json) {
    userName = json['userName'];
    email = json['email'];
    token = json['token'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    isAuthenticated = json['isAuthenticated'];
    refreshTokenExpiration = json['refreshTokenExpiration'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = userName;
    map['email'] = email;
    map['token'] = token;
    map['roles'] = roles;
    map['isAuthenticated'] = isAuthenticated;
    map['refreshTokenExpiration'] = refreshTokenExpiration;
    return map;
  }
}
