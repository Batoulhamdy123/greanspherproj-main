import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../entities/LoginResponseEntity .dart';
import '../repository/LoginRepositoryContract.dart';

@injectable
class LoginUseCase {
  LoginRepositoryContract loginRepository;

  LoginUseCase({required this.loginRepository});

  Future<Either<Failures, LoginResponseEntity>> invoke(
    String email,
    String password,
  ) {
    return loginRepository.login(
      email,
      password,
    );
  }
}
