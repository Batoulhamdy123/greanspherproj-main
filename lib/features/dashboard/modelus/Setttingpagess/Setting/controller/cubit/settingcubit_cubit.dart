import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/CustomWidget/custom_bottom_sheet.dart';

import '../../../../../../auth/register/view/pages/register_screen.dart';

part 'settingcubit_state.dart';

class SettingcubitCubit extends Cubit<SettingcubitState> {
  SettingcubitCubit() : super(SettingcubitInitial());
  final PageController Settingcontroller = PageController();
  void showBottomSheet(BuildContext context, String type) {
    if (type == "notifications") {
      CustomBottomSheet.show(
        context,
        title: "Disabled",
        message:
            "To manage your application notifications,please go to \nSettings > Notifications for the  ‘GreenSphere’ app ",
        primaryButtonText: "Cancel",
        onPrimaryPressed: () {
          Navigator.pop(context);
        },
        secondaryButtonText: "Setting",
        onSecondaryPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (type == "language") {
      CustomBottomSheet.show(
        context,
        title: "Choose Language",
        message: "Select your preferred language.",
        primaryButtonText: "English",
        onPrimaryPressed: () {
          Navigator.pop(context);
        },
        secondaryButtonText: "Arabic",
        onSecondaryPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (type == "logout") {
      CustomBottomSheet.show(
        context,
        title: "Log Out",
        message: "Are you sure you want to log out?",
        primaryButtonText: "Cancel",
        onPrimaryPressed: () {
          Navigator.pop(context);
        },
        secondaryButtonText: "Log Out",
        onSecondaryPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        },
      );
    }
  }
}
