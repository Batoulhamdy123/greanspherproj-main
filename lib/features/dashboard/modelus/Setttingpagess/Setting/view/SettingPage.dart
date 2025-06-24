import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Profile/view/ProfilePage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/CustomWidget/CustomListTile.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/data/settings_list.dart'; // استيراد القائمة

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            "assets/images/arrowback.png",
            width: 25,
            height: 25,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          final item = settingsOptions[index];
          final bool isLastItem = index == settingsOptions.length - 1;

          return Column(
            children: [
              Customlisttile(
                title: item["title"],
                page: item["page"],
                isBottomSheet: item["isBottomSheet"] ?? false,
                type: item["type"],
                subtitle: item["subtitle"],
              ),
              if (!isLastItem) // لا تضف Divider بعد آخر عنصر
                Divider(
                  thickness: (item["title"] == "Change password" ||
                          item["title"] == "Country")
                      ? 20
                      : 2,
                  color: const Color(0xFFE6E6E6),
                  indent: 10,
                  endIndent: 10,
                ),
            ],
          );
        },
      ),
    );
  }
}
