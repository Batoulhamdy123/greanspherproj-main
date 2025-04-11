import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/logo 1.png",
          width: 85,
          height: 85,
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Hinted search text",
              suffixIcon: Icon(
                Icons.search,
                color: Colors.green,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ],
    );
  }
}
