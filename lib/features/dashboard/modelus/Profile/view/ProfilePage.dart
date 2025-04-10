import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/ABOUT/view/AboutApp.dart';
import 'package:greanspherproj/features/dashboard/modelus/Favourite/view/Favourite.dart';
import 'package:greanspherproj/features/dashboard/modelus/Order/view/OrderPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/PAY/view/PayPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Reward/view/Reward.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/SettingPage.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/pages/SettingPage.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  ProfileScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              top: 65,
              right: 16,
            ),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Text(
                    userName[0].toUpperCase(),
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/egypt.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 6),
                        Text("Egypt", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  child: Image.asset(
                    "assets/images/tdesign_setting-1.png",
                    width: 30,
                    height: 30,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.grey,
            height: 16,
          ),

          // Menu Items
          buildMenuItem(
              context, "assets/images/Vector.png", "Rewards", RewardsScreen()),
          buildMenuItem(
              context, "assets/images/List.png", "Your Order", OrdersScreen()),
          buildMenuItem(context, "assets/images/pay.png", "Pay", PayScreen()),
          buildMenuItem(context, "assets/images/favourite.png", "Favourite",
              FavouriteScreen()),
          buildMenuItem(context, "assets/images/Information.png", "About App",
              AboutAppScreen()),
        ],
      ),
    );
  }

  // Function to create menu items
  Widget buildMenuItem(
      BuildContext context, String imagePath, String text, Widget page) {
    return ListTile(
      leading: Image.asset(imagePath, width: 25, height: 25),
      title: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

// Dummy screens for navigation
