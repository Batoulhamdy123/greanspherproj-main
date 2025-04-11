import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/entities/LoginResponseEntity%20.dart';
import 'package:greanspherproj/domain/failures.dart';
import 'package:greanspherproj/domain/use_case/LoginUseCase%20.dart';
//import 'package:meta/meta.dart';

part 'logincubit_state.dart';

class LogincubitCubit extends Cubit<LogincubitState> {
  LoginUseCase loginUseCase;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LogincubitCubit({required this.loginUseCase}) : super(LogincubitInitial());

  static LogincubitCubit get(context) => BlocProvider.of(context);

  void register() async {
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
