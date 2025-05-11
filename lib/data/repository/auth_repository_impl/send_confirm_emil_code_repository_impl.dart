import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/auth_remote_data_source/send_confirm_email_code_remote_data_source/send_confirm_email_code_remote_data_source.dart';
import 'package:greanspherproj/domain/entities/SendConfirmEmailCodeResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/SendConfirmEmailRepositoryContract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SendConfirmEmailRepositoryContract)
class SendConfirmEmailCodeRepositoryImpl
    implements SendConfirmEmailRepositoryContract {
  SendConfirmEmailCodeRemoteDataSource confirmEmailCodeRemoteDataSource;

  SendConfirmEmailCodeRepositoryImpl(
      {required this.confirmEmailCodeRemoteDataSource});

  @override
  Future<Either<Failures, SendConfirmEmailCodeResponseEntity>>
      sendConfirmEmailCode(
    String provider,
    String email,
  ) async {
    var either = await confirmEmailCodeRemoteDataSource.sendConfirmEmailCode(
      provider,
      email,
    );
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
