import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/failures.dart';

abstract class HomeRepository {
  Future<Either<Failures, CategoryResponseEntity>> getCategory();
}
