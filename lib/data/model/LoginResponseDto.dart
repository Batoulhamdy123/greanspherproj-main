import 'package:greanspherproj/domain/entities/LoginResponseEntity.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';

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
    if (succeeded == true && data?.token != null && data?.userName != null) {
      // <--- إضافة && data?.userName != null
      DateTime expiryDate = data!.refreshTokenExpiration != null
          ? DateTime.tryParse(data!.refreshTokenExpiration!) ??
              DateTime.now().add(const Duration(hours: 24))
          : DateTime.now().add(const Duration(hours: 24));

      // حفظ الـ Token الجديد واسم المستخدم في shared_preferences
      ApiService.saveUserAuthToken(data!.token!, expiryDate, data!.userName!);
    }
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
