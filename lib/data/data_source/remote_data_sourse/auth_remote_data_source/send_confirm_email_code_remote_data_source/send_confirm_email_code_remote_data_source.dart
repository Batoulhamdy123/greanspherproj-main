import 'package:dartz/dartz.dart';
import '../../../../../domain/entities/SendConfirmEmailCodeResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class SendConfirmEmailCodeRemoteDataSource {
  Future<Either<Failures, SendConfirmEmailCodeResponseEntity>>
      sendConfirmEmailCode(
    String provider,
    String email,
  );
}
