import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../entities/ResetPasswordResponseEntity.dart';

abstract class ResetPasswordRepositoryContract {
  Future<Either<Failures, ResetPasswordResponseEntity>> resetPassword(
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  );
}
