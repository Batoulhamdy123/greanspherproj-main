import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/auth_remote_data_source/register_remote_data_source/register_remote_data_source.dart';
import 'package:greanspherproj/domain/entities/LoginResponseEntity%20.dart';
//import 'package:greanspherproj/data/data_source/remote_data_sourse/auth_remote_data_source/register_remote_data_source/register_remote_data_source.dart';
import 'package:greanspherproj/domain/entities/RegisterResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/RegisterRepositoryContract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRepositoryContract)
class RegisterRepositoryImpl implements RegisterRepositoryContract {
  RegisterRemoteDataSource registerRemoteDataSource;

  RegisterRepositoryImpl({required this.registerRemoteDataSource});
  @override
  Future<Either<Failures, RegisterResponseEntity>> register(
      String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPassword) async {
    var either = await registerRemoteDataSource.register(
        firstName, lastName, userName, email, password, confirmPassword);
    return either.fold((error) => Left(error), (response) => Right(response));
  }

  Future<Either<Failures, LoginResponseEntity>> Login(
    String email,
    String password,
  ) async {
    var either = await registerRemoteDataSource.Login(email, password);
    return either.fold((e) => left(e), (Response) => Right(Response));

    ///return null;
  }
}
