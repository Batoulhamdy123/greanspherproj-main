import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resource/constant_manager.dart';
import '../../../../model/ConfirmEmailResponseDto.dart';
import 'confirm_email_code_remote_data_source.dart';

@Injectable(as: ConfirmEmailCodeRemoteDataSource)
class ConfirmEmailCodeRemoteDataSourceImpl
    implements ConfirmEmailCodeRemoteDataSource {
  ApiManager apiManager;

  ConfirmEmailCodeRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, ConfirmEmailResponseDto>> confirmEmailCode(
    String provider,
    String email,
    String token,
  ) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        print(""
            "Sending email: $email, provider: $provider, "
            "token: $token");
        var response = await apiManager.postData(
          EndPoints.confirmEmailCode,
          body: {'provider': provider, "email": email, "token": token},
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var confirmEmailResponse =
            ConfirmEmailResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(confirmEmailResponse);
        } else {
          print(confirmEmailResponse.message);
          return Left(ServerError(errorMessage: confirmEmailResponse.message!));
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
