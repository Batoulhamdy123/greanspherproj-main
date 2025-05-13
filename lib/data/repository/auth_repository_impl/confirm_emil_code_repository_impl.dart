import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/ConfirmEmailResponseEntity.dart';
import '../../../domain/repository/confirmEmailRepositoryContract.dart';
import '../../data_source/remote_data_sourse/auth_remote_data_source/confirm_email_code_remote_data_source/confirm_email_code_remote_data_source.dart';

@Injectable(as: ConfirmEmailRepositoryContract)
class ConfirmEmailCodeRepositoryImpl implements ConfirmEmailRepositoryContract {
  ConfirmEmailCodeRemoteDataSource confirmEmailCodeRemoteDataSource;

  ConfirmEmailCodeRepositoryImpl(
      {required this.confirmEmailCodeRemoteDataSource});

  @override
  Future<Either<Failures, ConfirmEmailResponseEntity>> confirmEmailCode(
    String provider,
    String email,
    String token,
  ) async {
    var either = await confirmEmailCodeRemoteDataSource.confirmEmailCode(
        provider, email, token);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
