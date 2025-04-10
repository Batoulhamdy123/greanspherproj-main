import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/use_case/RegisterUseCase.dart';
import 'package:greanspherproj/features/auth/register/controller/cubit/signupcubit_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterScreenCubit extends Cubit<RegisterCubitState> {
  RegisterUseCase registerUseCase;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  RegisterScreenCubit({required this.registerUseCase})
      : super(RegisterCubitInitialState());

  static RegisterScreenCubit get(context) => BlocProvider.of(context);

  void register() async {
    emit(RegisterCubitLoadingState());
    var either = await registerUseCase.invoke(
        firstNameController.text,
        lastNameController.text,
        userNameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text);
    either.fold(
        (ifLeft) => emit(RegisterCubitErrorState(failures: ifLeft)),
        (ifRight) =>
            emit(RegisterCubitSuccessState(registerResponseEntity: ifRight)));
  }
}
