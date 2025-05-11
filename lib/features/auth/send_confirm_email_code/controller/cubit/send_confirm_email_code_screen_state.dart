import 'package:greanspherproj/domain/entities/SendConfirmEmailCodeResponseEntity.dart';
import '../../../../../domain/failures.dart';

abstract class SendConfirmEmailCodeScreenState {}

class SendConfirmEmailCodeInitialState
    extends SendConfirmEmailCodeScreenState {}

class SendConfirmEmailCodeLoadingState
    extends SendConfirmEmailCodeScreenState {}

class SendConfirmEmailCodeErrorState extends SendConfirmEmailCodeScreenState {
  Failures failures;

  SendConfirmEmailCodeErrorState({required this.failures});
}

class SendConfirmEmailCodeSuccessState extends SendConfirmEmailCodeScreenState {
  SendConfirmEmailCodeResponseEntity sendConfirmEmailCodeResponseEntity;

  SendConfirmEmailCodeSuccessState(
      {required this.sendConfirmEmailCodeResponseEntity});
}
