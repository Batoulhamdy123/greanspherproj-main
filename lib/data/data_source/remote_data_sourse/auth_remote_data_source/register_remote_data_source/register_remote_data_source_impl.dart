import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/auth_remote_data_source/register_remote_data_source/register_remote_data_source.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utilities/constant_manager.dart';
import '../../../../model/RegisterResponseDto.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  ApiManager apiManager;

  RegisterRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Either<Failures, RegisterResponseDto>> register(
      String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPassword) async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        var response = await apiManager.postData(
          EndPoints.register,
          body: {
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "email": email,
            "password": password,
            "confirmPassword": confirmPassword
          },
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var registerResponse = RegisterResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(registerResponse);
        } else {
          return Left(ServerError(errorMessage: registerResponse.message!));
        }
      } else {
        return Left(NetworkError(errorMessage: AppConstants.networkError));
      }
    } catch (e) {
      return Left(Failures(errorMessage: e.toString()));
    }
  }

}
