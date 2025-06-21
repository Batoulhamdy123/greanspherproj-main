import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/use_case/get_categories_use_case.dart';
import 'package:injectable/injectable.dart';

import 'home_view_model_state.dart';

@injectable
class HomeViewModelCubit extends Cubit<HomeViewModelState> {
  GetCategoriesUseCase getCategoriesUseCase;
  HomeViewModelCubit({required this.getCategoriesUseCase})
      : super(HomeViewModelInitial());

  static HomeViewModelCubit get(context) => BlocProvider.of(context);

  void getCategories(String productName) async {
    emit(HomeCategoriesLoadingState());
    var either = await getCategoriesUseCase.invoke(productName);
    either.fold((error) {
      emit(HomeCategoriesErrorState(failures: error));
    }, (success) {
      emit(HomeCategoriesSuccessState(categoryResponseEntity: success));
    });
  }
}
