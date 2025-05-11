import '../../domain/entities/SendConfirmEmailCodeResponseEntity.dart';

class SendConfirmEmailCodeResponseDto
    extends SendConfirmEmailCodeResponseEntity {
  SendConfirmEmailCodeResponseDto({
    super.errors,
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  SendConfirmEmailCodeResponseDto.fromJson(dynamic json) {
    data = json['data'] != null
        ? SendConfirmEmailCodeDataDto.fromJson(json['data'])
        : null;
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }
}

class SendConfirmEmailCodeDataDto extends SendConfirmEmailCodeDataEntity {
  SendConfirmEmailCodeDataDto({
    super.codeExpiration,
  });

  SendConfirmEmailCodeDataDto.fromJson(dynamic json) {
    codeExpiration = json['codeExpiration'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['codeExpiration'] = codeExpiration;
    return map;
  }
}
