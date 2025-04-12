import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';

abstract class RegisterRemoteDataSource {
  Future<Either<Failures, RegisterResponseEntity>> register(
      String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPassword);
}
