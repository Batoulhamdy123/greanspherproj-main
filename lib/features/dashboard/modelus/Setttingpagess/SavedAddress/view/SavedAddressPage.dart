import 'package:flutter/material.dart';
import 'package:greanspherproj/location_manager.dart';

class SavedAddressPage extends StatelessWidget {
  LocationManager locationManager = LocationManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/images/arrowback.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Text(
          "Addresses",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Add",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ))
        ],
      ),
      body: Center(
        child: Text(""),
      ),
    );
  }
}
