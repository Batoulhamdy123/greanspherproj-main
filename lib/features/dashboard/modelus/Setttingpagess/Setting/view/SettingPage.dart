import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // لاستخدام UserProfile
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/view/Pages/AccountInfoPage.dart'; // AccountInfoScreen
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangeEmailPage/view/ChangeEmailPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangePasswordPgd/view/ChangePaswwordPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/SavedAddress/view/SavedAddressPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/controller/cubit/settingcubit_cubit.dart'; // لو بتستخدم SettingcubitCubit
import 'package:flutter_bloc/flutter_bloc.dart'; // لو بتستخدم BlocProvider
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/CustomWidget/CustomListTile.dart'; // CustomListTile

class SettingsScreen extends StatelessWidget {
  // تستقبل userProfile و onProfileUpdated من ProfileScreen
  final UserProfile? userProfile;
  final VoidCallback onProfileUpdated;

  const SettingsScreen(
      {Key? key, this.userProfile, required this.onProfileUpdated})
      : super(key: key); // <--- تم تغيير Constructor

  @override
  Widget build(BuildContext context) {
    // تعريف قائمة settingsOptions هنا داخل build
    final List<Map<String, dynamic>> settingsOptions = [
      {
        "title": "Account info",
        "type": "account_info",
      },
      {"title": "Saved Addresses", "page": const SavedAddressPage()},
      {"title": "Change email", "page": ChangeEmailScreen()},
      {"title": "Change password", "page": ChangePasswordScreen()},
      {
        "title": "Notifications",
        "isBottomSheet": true,
        "type": "notifications"
      },
      {
        "title": "Theme",
        "isBottomSheet": true,
        "type": "theme",
        "subtitle": "White"
      },
      {
        "title": "Language",
        "isBottomSheet": true,
        "type": "language",
        "subtitle": "English"
      },
      {
        "title": "Country",
        "isBottomSheet": true,
        "type": "country",
        "subtitle": "Egypt"
      },
      {"title": "Log out", "isBottomSheet": true, "type": "logout"},
    ];

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
                isBottomSheet: item["isBottomSheet"] ?? false,
                type: item["type"],
                subtitle: item["subtitle"],
                // هنا سنحدد الـ page بناءً على الـ type
                page: item["type"] ==
                        "account_info" // <--- لو النوع "account_info"
                    ? AccountInfoScreen(
                        // <--- ننشئ AccountInfoScreen هنا
                        userProfile:
                            userProfile, // <--- نمرر userProfile المستلم
                        onProfileUpdated:
                            onProfileUpdated, // <--- نمرر onProfileUpdated المستلم
                      )
                    : item["page"], // لو مش account_info، نمرر الـ page العادية
              ),
              if (!isLastItem)
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
