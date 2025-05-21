import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/ForgetPasswordResponseEntity.dart';

import '../../../../../domain/failures.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<Either<Failures, ForgetPasswordResponseEntity>>
      forgetPasswordConfirmEmailCode(
    String provider,
    String email,
  );
}
