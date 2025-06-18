import 'package:bloc/bloc.dart';
import 'package:greanspherproj/domain/entities/CategoryResposeEntity.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/use_case/get_categories_use_case.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_view_model_state.dart';

@injectable
class HomeViewModelCubit extends Cubit<HomeViewModelState> {
  GetCategoriesUseCase getCategoriesUseCase;
  HomeViewModelCubit({required this.getCategoriesUseCase})
      : super(HomeViewModelInitial());
  void getCategories() async {
    emit(HomeCategoriesLoadingState());
    var either = await getCategoriesUseCase.invoke();
    either.fold((error) {
      emit(HomeCategoriesErrorState(failures: error));
    }, (Response) {
      emit(HomeCategoriesSuccessState(categoryResponseEntity: Response));
    });
  }
}
