import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/ForgetPasswordResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../repository/ForgetPasswordRepositoryContract.dart';

@injectable
class ForgetPasswordUseCase {
  ForgetPasswordRepositoryContract forgetPasswordRepositoryContract;

  ForgetPasswordUseCase({required this.forgetPasswordRepositoryContract});

  Future<Either<Failures, ForgetPasswordResponseEntity>> invoke(
    String provider,
    String email,
  ) {
    return forgetPasswordRepositoryContract.forgetPasswordConfirmEmailCode(
        provider, email);
  }
}
