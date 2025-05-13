import 'package:greanspherproj/domain/entities/ConfirmEmailResponseEntity.dart';

class ConfirmEmailResponseDto extends ConfirmEmailResponseEntity {
  ConfirmEmailResponseDto({
    super.errors,
    super.data,
    super.statusCode,
    super.succeeded,
    super.message,
  });

  ConfirmEmailResponseDto.fromJson(dynamic json) {
    data = json['data'];
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    map['statusCode'] = statusCode;
    map['succeeded'] = succeeded;
    map['message'] = message;
    return map;
  }
}
