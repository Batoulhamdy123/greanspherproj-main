import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/home_remote_datasourse/home_remote_data_source.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract {
  HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.homeRemoteDataSource});
  @override
  Future<Either<Failures, CategoryResponseEntity>> getCategory(
      String productName) async {
    var either = await homeRemoteDataSource.getCategory(productName);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}
