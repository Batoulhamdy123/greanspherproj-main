import 'package:greanspherproj/domain/entities/ForgetPasswordResponseEntity.dart';

import '../../../../../domain/failures.dart';

abstract class ForgetPasswordScreenState {}

class ForgetPasswordInitialState extends ForgetPasswordScreenState {}

class ForgetPasswordLoadingState extends ForgetPasswordScreenState {}

class ForgetPasswordErrorState extends ForgetPasswordScreenState {
  Failures failures;

  ForgetPasswordErrorState({required this.failures});
}

class ForgetPasswordSuccessState extends ForgetPasswordScreenState {
  ForgetPasswordResponseEntity forgetPasswordResponseEntity;

  ForgetPasswordSuccessState({required this.forgetPasswordResponseEntity});
}
