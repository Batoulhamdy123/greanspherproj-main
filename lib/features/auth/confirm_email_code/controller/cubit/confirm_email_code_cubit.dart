import 'dart:async';

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
  Timer? _timer;
  int _counter = 60;

  int get counter => _counter;

  void startTimer() {
    _counter = 60;
    emit(ConfirmEmailCodeTimerTick(_counter));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        _counter--;
        print("Timer tick: $_counter");

        emit(ConfirmEmailCodeTimerTick(_counter));
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  void sendConfirmEmailCode(String provider, String email) async {
    emit(ConfirmEmailCodeLoadingState());
    var either = await confirmEmailUseCase.invoke(
        provider, email, pinCodeController.text);
    either.fold(
        (ifLeft) => emit(ConfirmEmailCodeErrorState(failures: ifLeft)),
        (ifRight) => emit(
            ConfirmEmailCodeSuccessState(confirmEmailResponseEntity: ifRight)));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    pinCodeController.dispose();
    return super.close();
  }
}
