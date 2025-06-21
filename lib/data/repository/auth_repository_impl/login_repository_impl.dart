import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/LoginResponseEntity.dart';
import '../../../domain/failures.dart';
import '../../../domain/repository/LoginRepositoryContract.dart';
import '../../data_source/remote_data_sourse/auth_remote_data_source/login_remote_data_source/login_remote_data_source.dart';

@Injectable(as: LoginRepositoryContract)
class LoginRepositoryImpl implements LoginRepositoryContract {
  LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl({required this.loginRemoteDataSource});

  @override
  Future<Either<Failures, LoginResponseEntity>> login(
    String email,
    String password,
  ) async {
    var either = await loginRemoteDataSource.login(email, password);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
