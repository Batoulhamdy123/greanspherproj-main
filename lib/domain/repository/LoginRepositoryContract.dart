import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../entities/LoginResponseEntity.dart';

abstract class LoginRepositoryContract {
  Future<Either<Failures, LoginResponseEntity>> login(
    String email,
    String password,
  );
}
