part of 'home_view_model_cubit.dart';

@immutable
sealed class HomeViewModelState {}

final class HomeViewModelInitial extends HomeViewModelState {}

final class HomeCategoriesLoadingState extends HomeViewModelState {}

final class HomeCategoriesErrorState extends HomeViewModelState {
  Failures failures;
  HomeCategoriesErrorState({required this.failures});
}

final class HomeCategoriesSuccessState extends HomeViewModelState {
  CategoryResponseEntity categoryResponseEntity;
  HomeCategoriesSuccessState({required this.categoryResponseEntity});
}
