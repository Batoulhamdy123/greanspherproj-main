import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/ForgetPasswordResponseEntity.dart';
import '../../../domain/repository/ForgetPasswordRepositoryContract.dart';
import '../../data_source/remote_data_sourse/auth_remote_data_source/forget_password_remote_data_source/forget_password_remote_data_source.dart';

@Injectable(as: ForgetPasswordRepositoryContract)
class ForgetPasswordRepositoryImpl implements ForgetPasswordRepositoryContract {
  ForgetPasswordRemoteDataSource forgetPasswordRemoteDataSource;

  ForgetPasswordRepositoryImpl({required this.forgetPasswordRemoteDataSource});

  @override
  Future<Either<Failures, ForgetPasswordResponseEntity>>
      forgetPasswordConfirmEmailCode(
    String provider,
    String email,
  ) async {
    var either =
        await forgetPasswordRemoteDataSource.forgetPasswordConfirmEmailCode(
      provider,
      email,
    );
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
