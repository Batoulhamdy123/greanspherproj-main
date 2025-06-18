import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:greanspherproj/domain/failures.dart';

class GetCategoriesUseCase {
  HomeRepository homeRepository;
  GetCategoriesUseCase({required this.homeRepository});
  Future<Either<Failures, CategoryResponseEntity>> invoke() {
    return homeRepository.getCategory();
  }
}
