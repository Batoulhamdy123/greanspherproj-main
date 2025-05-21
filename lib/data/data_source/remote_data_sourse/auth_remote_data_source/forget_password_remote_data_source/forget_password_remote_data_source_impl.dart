import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resource/constant_manager.dart';
import '../../../../model/ForgetPasswordResponseDto.dart';
import 'forget_password_remote_data_source.dart';

@Injectable(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
  ApiManager apiManager;

  ForgetPasswordRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, ForgetPasswordResponseDto>>
      forgetPasswordConfirmEmailCode(
    String provider,
    String email,
  ) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        print("Sending email: $email, provider: $provider");
        var response = await apiManager.postData(
          EndPoints.forgetPassword,
          body: {
            'provider': provider,
            "email": email,
          },
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var forgetPasswordResponse =
            ForgetPasswordResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(forgetPasswordResponse);
        } else {
          print(forgetPasswordResponse.message);
          return Left(
              ServerError(errorMessage: forgetPasswordResponse.message!));
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
