import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/LoginResponseEntity%20.dart';
import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/RegisterRepositoryContract.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  RegisterRepositoryContract LoginRepository;

  LoginUseCase({required this.LoginRepository});

  Future<Either<Failures, LoginResponseEntity>> invoke(
    String email,
    String password,
  ) {
    return LoginRepository.Login(
      email,
      password,
    );
  }
}
