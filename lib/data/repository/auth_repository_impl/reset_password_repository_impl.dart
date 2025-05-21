import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/ResetPasswordResponseEntity.dart';
import '../../../domain/repository/ResetPasswordRepositoryContract.dart';
import '../../data_source/remote_data_sourse/auth_remote_data_source/reset_password_remote_data_source/reset_password_remote_data_source.dart';

@Injectable(as: ResetPasswordRepositoryContract)
class ResetPasswordRepositoryImpl implements ResetPasswordRepositoryContract {
  ResetPasswordRemoteDataSource resetPasswordRemoteDataSource;

  ResetPasswordRepositoryImpl({required this.resetPasswordRemoteDataSource});

  @override
  Future<Either<Failures, ResetPasswordResponseEntity>> resetPassword(
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  ) async {
    var either = await resetPasswordRemoteDataSource.resetPassword(
        email, code, newPassword, confirmPassword);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
