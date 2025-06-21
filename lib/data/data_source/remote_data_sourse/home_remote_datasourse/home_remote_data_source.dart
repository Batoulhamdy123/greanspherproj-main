import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';

import '../../../../../domain/failures.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failures, CategoryResponseEntity>> getCategory(
      String productName);
}
