import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../entities/ResetPasswordResponseEntity.dart';
import '../repository/ResetPasswordRepositoryContract.dart';

@injectable
class ResetPasswordUseCase {
  ResetPasswordRepositoryContract resetPasswordRepositoryContract;

  ResetPasswordUseCase({required this.resetPasswordRepositoryContract});

  Future<Either<Failures, ResetPasswordResponseEntity>> invoke(
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  ) {
    return resetPasswordRepositoryContract.resetPassword(
        email, code, newPassword, confirmPassword);
  }
}
