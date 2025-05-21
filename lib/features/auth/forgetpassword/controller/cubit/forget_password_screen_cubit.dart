import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/use_case/ForgetPasswordUseCase.dart';
import 'forget_password_screen_state.dart';

@injectable
class ForgetPasswordScreenCubit extends Cubit<ForgetPasswordScreenState> {
  ForgetPasswordUseCase forgetPasswordUseCase;
  TextEditingController emailController = TextEditingController();

  ForgetPasswordScreenCubit({required this.forgetPasswordUseCase})
      : super(ForgetPasswordInitialState());

  static ForgetPasswordScreenCubit get(context) => BlocProvider.of(context);

  void forgetPasswordConfirmEmailCode(String provider) async {
    emit(ForgetPasswordLoadingState());
    var either =
        await forgetPasswordUseCase.invoke(provider, emailController.text);
    either.fold(
        (ifLeft) => emit(ForgetPasswordErrorState(failures: ifLeft)),
        (ifRight) => emit(
            ForgetPasswordSuccessState(forgetPasswordResponseEntity: ifRight)));
  }
}
