import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../entities/ConfirmEmailResponseEntity.dart';
import '../repository/confirmEmailRepositoryContract.dart';

@injectable
class ConfirmEmailUseCase {
  ConfirmEmailRepositoryContract confirmEmailRepositoryContract;

  ConfirmEmailUseCase({required this.confirmEmailRepositoryContract});

  Future<Either<Failures, ConfirmEmailResponseEntity>> invoke(
    String provider,
    String email,
    String token,
  ) {
    return confirmEmailRepositoryContract.confirmEmailCode(
        provider, email, token);
  }
}
