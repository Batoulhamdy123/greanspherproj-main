import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/use_case/LoginUseCase%20.dart';
import 'package:injectable/injectable.dart';

import 'logincubit_state.dart';

@injectable
class LoginScreenCubit extends Cubit<LoginCubitState> {
  LoginUseCase loginUseCase;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginScreenCubit({required this.loginUseCase}) : super(LoginCubitInitial());

  static LoginScreenCubit get(context) => BlocProvider.of(context);

  void login() async {
    emit(LoginCubitLoadingState());
    var either = await loginUseCase.invoke(
      emailController.text,
      passwordController.text,
    );
    either.fold(
        (ifLeft) => emit(LoginCubitErrorState(failures: ifLeft)),
        (ifRight) =>
            emit(LoginCubitSuccessState(loginResponseEntity: ifRight)));
  }
}
