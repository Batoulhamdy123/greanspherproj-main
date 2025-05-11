import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../entities/SendConfirmEmailCodeResponseEntity.dart';

abstract class SendConfirmEmailRepositoryContract {
  Future<Either<Failures, SendConfirmEmailCodeResponseEntity>>
      sendConfirmEmailCode(
    String provider,
    String email,
  );
}
