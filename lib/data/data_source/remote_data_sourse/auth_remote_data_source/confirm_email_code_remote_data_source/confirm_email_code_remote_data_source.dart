import 'package:dartz/dartz.dart';

import '../../../../../domain/entities/ConfirmEmailResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class ConfirmEmailCodeRemoteDataSource {
  Future<Either<Failures, ConfirmEmailResponseEntity>> confirmEmailCode(
    String provider,
    String email,
    String token,
  );
}
