part of 'logincubit_cubit.dart';

abstract class LogincubitState {}

class LogincubitInitial extends LogincubitState {}

class LoginCubitLoadingState extends LogincubitState {}

class LoginCubitErrorState extends LogincubitState {
  late Failures failures;

  LoginCubitErrorState({required this.failures});
}

class LoginCubitSuccessState extends LogincubitState {
  LoginResponseEntity loginResponseEntity;

  LoginCubitSuccessState({required this.loginResponseEntity});
}
