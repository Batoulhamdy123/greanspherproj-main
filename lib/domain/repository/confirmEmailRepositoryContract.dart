import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../entities/ConfirmEmailResponseEntity.dart';

abstract class ConfirmEmailRepositoryContract {
  Future<Either<Failures, ConfirmEmailResponseEntity>> confirmEmailCode(
    String provider,
    String email,
    String token,
  );
}
