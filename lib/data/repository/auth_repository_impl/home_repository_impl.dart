import 'package:dartz/dartz.dart';
import 'package:greanspherproj/data/data_source/remote_data_sourse/home_remote_datasourse/home_remote_data_sourse.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRemoteDataSourse homeRemoteDataSourse;
  HomeRepositoryImpl({required this.homeRemoteDataSourse});
  @override
  Future<Either<Failures, CategoryResponseEntity>> getCategory() async {
    var either = await homeRemoteDataSourse.getCategory();
    return either.fold((l) => Left(l), (Response) => Right(Response));
  }
}
