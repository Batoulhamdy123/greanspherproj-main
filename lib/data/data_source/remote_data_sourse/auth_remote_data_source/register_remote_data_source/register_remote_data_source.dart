import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/LoginResponseEntity%20.dart';
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
  Future<Either<Failures, LoginResponseEntity>> Login(
    String email,
    String password,
  );
}
