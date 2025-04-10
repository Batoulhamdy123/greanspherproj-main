import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/RegisterRepositoryContract.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  RegisterRepositoryContract registerRepository;

  RegisterUseCase({required this.registerRepository});

  Future<Either<Failures, RegisterResponseEntity>> invoke(
      String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPassword) {
    return registerRepository.register(
        firstName, lastName, userName, email, password, confirmPassword);
  }
}
