import 'package:greanspherproj/domain/entities/ResetPasswordResponseEntity.dart';
import 'package:greanspherproj/domain/failures.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordErrorState extends ResetPasswordState {
  Failures failures;

  ResetPasswordErrorState({required this.failures});
}

class ResetPasswordSuccessState extends ResetPasswordState {
  ResetPasswordResponseEntity resetPasswordResponseEntity;

  ResetPasswordSuccessState({required this.resetPasswordResponseEntity});
}
