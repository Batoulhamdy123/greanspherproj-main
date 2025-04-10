part of 'account_info_cubit.dart';

abstract class AccountInfoState {}

class AccountInfoInitial extends AccountInfoState {}

class AccountInfoEditingState extends AccountInfoState {
  final bool isEditing;
  AccountInfoEditingState(this.isEditing);
}

class AccountInfoDateSelectedState extends AccountInfoState {
  final String selectedDate;
  AccountInfoDateSelectedState(this.selectedDate);
}

class AccountInfoGenderSelectedState extends AccountInfoState {
  final String selectedGender;
  AccountInfoGenderSelectedState(this.selectedGender);
}
