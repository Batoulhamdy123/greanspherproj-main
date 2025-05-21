import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/ForgetPasswordResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';

abstract class ForgetPasswordRepositoryContract {
  Future<Either<Failures, ForgetPasswordResponseEntity>>
      forgetPasswordConfirmEmailCode(
    String provider,
    String email,
  );
}
