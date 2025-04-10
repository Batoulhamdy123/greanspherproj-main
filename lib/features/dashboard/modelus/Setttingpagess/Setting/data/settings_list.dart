import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/view/Pages/AccountInfoPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangeEmailPage/view/ChangeEmailPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangePasswordPgd/view/ChangePaswwordPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/SavedAddress/view/SavedAddressPage.dart';

final List<Map<String, dynamic>> settingsOptions = [
  {"title": "Account info", "page": AccountInfoScreen()},
  {"title": "Saved Addresses", "page": SavedAddressPage()},
  {"title": "Change email", "page": ChangeEmailScreen()},
  {"title": "Change password", "page": ChangePasswordScreen()},
  {"title": "Notifications", "isBottomSheet": true, "type": "notifications"},
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
