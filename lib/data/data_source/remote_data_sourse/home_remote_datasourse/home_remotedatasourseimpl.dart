import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:greanspherproj/core/resource/constant_manager.dart';
import 'package:greanspherproj/data/api_manager/api_manager.dart';
import 'package:greanspherproj/data/api_manager/end_points.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/home_remote_datasourse/home_remote_data_sourse.dart';
import 'package:greanspherproj/data/model/CategoryResponseDto.dart';

import 'package:greanspherproj/domain/failures.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRemoteDataSourse)
class HomeRemotedatasourseimpl implements HomeRemoteDataSourse {
  ApiManager apiManager;
  HomeRemotedatasourseimpl({required this.apiManager});
  @override
  Future<Either<Failures, CategoryResponseDto>> getCategory() async {
    try {
      var checkResult = await Connectivity().checkConnectivity();
      if (checkResult.contains(ConnectivityResult.wifi) ||
          checkResult.contains(ConnectivityResult.mobile)) {
        var response = await apiManager.getData(
          EndPoints.getcategory,
          headers: {
            "x-api-key": EndPoints.apiKey,
            "Content-Type": 'application/json'
          },
        );
        var getCategoryResponse = CategoryResponseDto.fromJson(response.data);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(getCategoryResponse);
        } else {
          return Left(ServerError(errorMessage: getCategoryResponse.message!));
        }
      } else {
        return Left(NetworkError(errorMessage: AppConstants.networkError));
      }
    } catch (e) {
      return Left(Failures(errorMessage: e.toString()));
    }
  }
}
