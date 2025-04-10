import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);

class TextFormFieldItem extends StatelessWidget {
  final String label;
  final String obscuringCharacter;

  final MyValidator? validator;

  final TextInputType keyboardType;

  final TextEditingController controller;

  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? edgeInsetsGeometry;

  const TextFormFieldItem(
      {super.key,
      this.obscuringCharacter = '*',
      this.edgeInsetsGeometry,
      this.prefixIcon,
      this.suffixIcon,
      required this.label,
      this.validator,
      this.keyboardType = TextInputType.text,
      required this.controller,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          decoration: decoration.copyWith(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: label,
              contentPadding: edgeInsetsGeometry)),
    );
  }
}

InputDecoration decoration = const InputDecoration();
