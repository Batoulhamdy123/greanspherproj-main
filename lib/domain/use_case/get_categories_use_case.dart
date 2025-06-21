import 'package:dartz/dartz.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/repository/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  HomeRepositoryContract homeRepository;
  GetCategoriesUseCase({required this.homeRepository});

  Future<Either<Failures, CategoryResponseEntity>> invoke(String productName) {
    return homeRepository.getCategory(productName);
  }
}
