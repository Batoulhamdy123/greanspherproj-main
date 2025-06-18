import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';

import '../../../../../domain/entities/ConfirmEmailResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class HomeRemoteDataSourse {
  Future<Either<Failures, CategoryResponseEntity>> getCategory();
}
