import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';

part 'vericationcubit_state.dart';

class VerficationcubitCubit extends Cubit<VericationcubitState> {
  VerficationcubitCubit() : super(VericationcubitInitial());
  TextEditingController verificationcontroller = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  String validCode = "12345";
  void onTapConfirm() {
    if (pinCodeController.text == validCode) {
      print("valid");
    } else
      print("invalid");
  }
}
