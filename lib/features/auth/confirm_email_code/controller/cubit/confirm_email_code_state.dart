import 'package:greanspherproj/domain/entities/ConfirmEmailResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';

abstract class ConfirmEmailCodeState {}

class ConfirmEmailCodeInitialState extends ConfirmEmailCodeState {}

class ConfirmEmailCodeLoadingState extends ConfirmEmailCodeState {}

class ConfirmEmailCodeErrorState extends ConfirmEmailCodeState {
  Failures failures;

  ConfirmEmailCodeErrorState({required this.failures});
}

class ConfirmEmailCodeSuccessState extends ConfirmEmailCodeState {
  ConfirmEmailResponseEntity confirmEmailResponseEntity;

  ConfirmEmailCodeSuccessState({required this.confirmEmailResponseEntity});
}

class ConfirmEmailCodeTimerTick extends ConfirmEmailCodeState {
  final int counter;

  ConfirmEmailCodeTimerTick(this.counter);
}
