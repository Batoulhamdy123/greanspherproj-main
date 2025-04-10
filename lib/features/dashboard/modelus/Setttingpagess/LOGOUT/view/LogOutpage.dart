import 'package:flutter/material.dart';

class LogOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "Account Info Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
