import 'package:dartz/dartz.dart';

import '../../../../../domain/entities/ResetPasswordResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<Either<Failures, ResetPasswordResponseEntity>> resetPassword(
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  );
}
