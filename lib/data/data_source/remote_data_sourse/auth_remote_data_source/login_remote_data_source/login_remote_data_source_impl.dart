import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utilities/constant_manager.dart';
import '../../../../model/LoginResponseDto .dart';
import 'login_remote_data_source.dart';

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  ApiManager apiManager;

  LoginRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, LoginResponseDto>> login(
      String email, String password) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        var response = await apiManager.postData(
          EndPoints.login,
          body: {
            "email": email,
            "password": password,
          },
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var loginResponse = LoginResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(loginResponse);
        } else {
          return Left(ServerError(errorMessage: loginResponse.message!));
        }
      } else {
        return Left(NetworkError(errorMessage: AppConstants.networkError));
      }
    } catch (e) {
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
