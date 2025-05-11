import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/SendConfirmEmailRepositoryContract.dart';
import 'package:injectable/injectable.dart';

import '../entities/SendConfirmEmailCodeResponseEntity.dart';

@injectable
class SendConfirmEmailUseCase {
  SendConfirmEmailRepositoryContract sendConfirmEmailRepositoryContract;

  SendConfirmEmailUseCase({required this.sendConfirmEmailRepositoryContract});

  Future<Either<Failures, SendConfirmEmailCodeResponseEntity>> invoke(
    String provider,
    String email,
  ) {
    return sendConfirmEmailRepositoryContract.sendConfirmEmailCode(
      provider,
      email,
    );
  }
}
