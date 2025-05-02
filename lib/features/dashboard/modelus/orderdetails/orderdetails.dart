import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Profile/view/ProfilePage.dart';

class orserDetails extends StatelessWidget {
  const orserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdersScreen()),
            );
          },
        ),
      ),
      body: Text("order details"),
    );
  }
}
