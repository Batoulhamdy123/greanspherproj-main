import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/domain/use_case/SendConfirmEmailUseCase.dart';
import 'package:greanspherproj/features/auth/send_confirm_email_code/controller/cubit/send_confirm_email_code_screen_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendConfirmEmailCodeScreenCubit
    extends Cubit<SendConfirmEmailCodeScreenState> {
  SendConfirmEmailUseCase sendConfirmEmailUseCase;
  TextEditingController emailController = TextEditingController();

  SendConfirmEmailCodeScreenCubit({required this.sendConfirmEmailUseCase})
      : super(SendConfirmEmailCodeInitialState());

  static SendConfirmEmailCodeScreenCubit get(context) =>
      BlocProvider.of(context);

  void sendConfirmEmailCode(String provider) async {
    emit(SendConfirmEmailCodeLoadingState());
    var either =
        await sendConfirmEmailUseCase.invoke(provider, emailController.text);
    either.fold(
        (ifLeft) => emit(SendConfirmEmailCodeErrorState(failures: ifLeft)),
        (ifRight) => emit(SendConfirmEmailCodeSuccessState(
            sendConfirmEmailCodeResponseEntity: ifRight)));
  }
}
