import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';

import '../../../../../domain/entities/LoginResponseEntity .dart';

abstract class LoginRemoteDataSource {
  Future<Either<Failures, LoginResponseEntity>> login(
    String email,
    String password,
  );
}
