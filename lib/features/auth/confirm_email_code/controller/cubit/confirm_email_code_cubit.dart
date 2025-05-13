import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/use_case/ConfirmEmailUseCase.dart';
import 'confirm_email_code_state.dart';

@injectable
class ConfirmEmailCodeCubit extends Cubit<ConfirmEmailCodeState> {
  ConfirmEmailUseCase confirmEmailUseCase;

  ConfirmEmailCodeCubit({required this.confirmEmailUseCase})
      : super(ConfirmEmailCodeInitialState());
  TextEditingController pinCodeController = TextEditingController();

  static ConfirmEmailCodeCubit get(context) => BlocProvider.of(context);

  void sendConfirmEmailCode(String provider, String email) async {
    emit(ConfirmEmailCodeLoadingState());
    var either = await confirmEmailUseCase.invoke(
        provider, email, pinCodeController.text);
    either.fold(
        (ifLeft) => emit(ConfirmEmailCodeErrorState(failures: ifLeft)),
        (ifRight) => emit(
            ConfirmEmailCodeSuccessState(confirmEmailResponseEntity: ifRight)));
  }
}
