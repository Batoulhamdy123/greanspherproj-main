import 'package:flutter/material.dart';

class RequiredImage extends StatelessWidget {
  const RequiredImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      "assets/images/loginpn.png",
      width: 180,
      height: 80,
    )
        /* Image(
        image: AssetImage(
          "assets/images/loginpn.png",
        ),
        width: 200,
        height: 180,
        //color: Color.fromARGB(255, 219, 149, 213),
      ),*/
        );
  }
}
