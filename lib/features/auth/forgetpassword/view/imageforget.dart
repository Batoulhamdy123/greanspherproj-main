import 'package:flutter/material.dart';

class ForgetImage extends StatelessWidget {
  const ForgetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/forget.png",
        width: 180,
        height: 160,
      ),
    );
  }
}
