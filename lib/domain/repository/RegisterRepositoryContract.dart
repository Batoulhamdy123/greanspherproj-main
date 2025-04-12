import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../entities/RegisterResponseEntity.dart';

abstract class RegisterRepositoryContract {
  Future<Either<Failures, RegisterResponseEntity>> register(
      String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPassword);
}
