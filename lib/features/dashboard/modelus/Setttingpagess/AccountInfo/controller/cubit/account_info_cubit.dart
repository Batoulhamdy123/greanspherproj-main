import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'account_info_state.dart';

class AccountInfoCubit extends Cubit<AccountInfoState> {
  AccountInfoCubit() : super(AccountInfoInitial());

  bool isEditing = false;
  String? gender;

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void toggleEditMode() {
    isEditing = !isEditing;
    emit(AccountInfoEditingState(isEditing));
  }

  Future<void> selectDate(BuildContext context) async {
    if (!isEditing) return;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      emit(AccountInfoDateSelectedState(dateController.text));
    }
  }

  void setGender(String value) {
    if (isEditing) {
      gender = value;
      emit(AccountInfoGenderSelectedState(value));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    return super.close();
  }
}
