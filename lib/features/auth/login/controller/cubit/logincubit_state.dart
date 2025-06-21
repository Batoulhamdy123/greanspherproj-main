import '../../../../../domain/entities/LoginResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class LoginCubitState {}

class LoginCubitInitial extends LoginCubitState {}

class LoginCubitLoadingState extends LoginCubitState {}

class LoginCubitErrorState extends LoginCubitState {
  Failures failures;

  LoginCubitErrorState({required this.failures});
}

class LoginCubitSuccessState extends LoginCubitState {
  LoginResponseEntity loginResponseEntity;

  LoginCubitSuccessState({required this.loginResponseEntity});
}
