import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/resource/constant_manager.dart';
import '../../../../model/ResetPasswordResponseDto.dart';
import 'reset_password_remote_data_source.dart';

@Injectable(as: ResetPasswordRemoteDataSource)
class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  ApiManager apiManager;

  ResetPasswordRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, ResetPasswordResponseDto>> resetPassword(
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        print(
            "Sending email: $email, code: $code , newPassword $newPassword ,confirmPassword $confirmPassword ");
        var response = await apiManager.postData(
          EndPoints.resetPassword,
          body: {
            "email": email,
            "code": code,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
          },
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var resetPasswordResponse =
            ResetPasswordResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(resetPasswordResponse);
        } else {
          print(resetPasswordResponse.message);
          return Left(
              ServerError(errorMessage: resetPasswordResponse.message!));
        }
      } else {
        return Left(NetworkError(errorMessage: AppConstants.networkError));
      }
    } catch (e) {
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
