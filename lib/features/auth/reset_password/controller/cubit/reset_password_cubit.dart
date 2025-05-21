import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/use_case/ResetPasswordUseCase.dart';
import 'package:greanspherproj/features/auth/reset_password/controller/cubit/reset_password_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordCubit({required this.resetPasswordUseCase})
      : super(ResetPasswordInitialState());
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  void resetPassword(
    String email,
    String code,
  ) async {
    emit(ResetPasswordLoadingState());
    var either = await resetPasswordUseCase.invoke(
        email, code, newPassword.text, confirmPassword.text);
    either.fold(
        (ifLeft) => emit(ResetPasswordErrorState(failures: ifLeft)),
        (ifRight) => emit(
            ResetPasswordSuccessState(resetPasswordResponseEntity: ifRight)));
  }
}
