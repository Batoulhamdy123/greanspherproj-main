import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/auth_remote_data_source/send_confirm_email_code_remote_data_source/send_confirm_email_code_remote_data_source.dart';
import 'package:greanspherproj/data/model/SendConfirmEmailCodeResponseDto.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resource/constant_manager.dart';

@Injectable(as: SendConfirmEmailCodeRemoteDataSource)
class SendConfirmEmailCodeRemoteDataSourceImpl
    implements SendConfirmEmailCodeRemoteDataSource {
  ApiManager apiManager;

  SendConfirmEmailCodeRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, SendConfirmEmailCodeResponseDto>>
      sendConfirmEmailCode(
    String provider,
    String email,
  ) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        print("Sending email: $email, provider: $provider");
        var response = await apiManager.postData(
          EndPoints.sendConfirmEmailCode,
          body: {
            'provider': provider,
            "email": email,
          },
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var sendConfirmEmailResponse =
            SendConfirmEmailCodeResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(sendConfirmEmailResponse);
        } else {
          print(sendConfirmEmailResponse.message);
          return Left(
              ServerError(errorMessage: sendConfirmEmailResponse.message!));
        }
      } else {
        return Left(NetworkError(errorMessage: AppConstants.networkError));
      }
    } catch (e) {
      print("${e.toString()}1111111111111111111111");
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
