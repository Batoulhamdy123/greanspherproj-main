//import 'package:greanspherproj/core/resource/validation.dart';
//import 'package:greanspherproj/lib/core/resource/validation.dart';
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/auth/changepassword/controller/cubit/changecubit_cubit.dart';

import '../../../../../core/widget/validation.dart';

// ignore: must_be_immutable
class CustomWidget extends StatelessWidget {
  CustomWidget({super.key, required this.hint_text});
  final String hint_text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ChangecubitCubit().passwordController1,
            keyboardType: TextInputType.text,
            validator: MyValidation.validatePassword,

            /* inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(\+20|015|011|010)\d{9}$')),
              // FilteringTextInputFormatter.deny(RegExp(r'(A-Z)'))
            ],*/
            decoration: decoration.copyWith(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility_off),
              hintText: hint_text,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            ),
            obscureText: true,
            obscuringCharacter: '*',
          ),
        ),
      ],
    );
  }

  InputDecoration decoration = InputDecoration();
}
