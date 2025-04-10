import '../../../../../domain/entities/RegisterResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class RegisterCubitState {}

class RegisterCubitInitialState extends RegisterCubitState {}

class RegisterCubitLoadingState extends RegisterCubitState {}

class RegisterCubitErrorState extends RegisterCubitState {
  Failures failures;

  RegisterCubitErrorState({required this.failures});
}

class RegisterCubitSuccessState extends RegisterCubitState {
  RegisterResponseEntity registerResponseEntity;

  RegisterCubitSuccessState({required this.registerResponseEntity});
}
