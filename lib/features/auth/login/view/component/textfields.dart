/*import 'package:flutter/material.dart';
import 'package:greanspherproj/core/utilities/validation.dart';
import 'package:greanspherproj/features/auth/login/controller/cubit/logincubit_cubit.dart';

// ignore: must_be_immutable
class TextFields extends StatelessWidget {
  TextFields({super.key, required this.controller});
  final LogincubitCubit controller;
//
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
            controller: controller.emailController1,
            keyboardType: TextInputType.text,
            validator: MyValidation.validateEmail,

            /* inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(\+20|015|011|010)\d{9}$')),
              // FilteringTextInputFormatter.deny(RegExp(r'(A-Z)'))
            ],*/
            decoration: decoration.copyWith(
              prefixIcon: const Icon(Icons.email),
              hintText: "Email",
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.passwordController3,
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
              hintText: "Password",
              contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            ),
            obscureText: true,
            obscuringCharacter: '*',
          ),
        ),
      ],
    );
  }

  InputDecoration decoration = InputDecoration(
      // suffixIcon: const Icon(Icons.email),
      /* border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),
    ),*/
      /* focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide:
          const BorderSide(color: Color.fromARGB(221, 19, 21, 29), width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(
            color: Color.fromARGB(183, 244, 70, 17), width: 1.0)),*/
      );
}
// InputDecoration decoration1 = InputDecoration()
*/
