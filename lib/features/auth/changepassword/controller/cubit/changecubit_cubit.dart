import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';

part 'changecubit_state.dart';

class ChangecubitCubit extends Cubit<ChangecubitState> {
  ChangecubitCubit() : super(ChangecubitInitial());
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
}
