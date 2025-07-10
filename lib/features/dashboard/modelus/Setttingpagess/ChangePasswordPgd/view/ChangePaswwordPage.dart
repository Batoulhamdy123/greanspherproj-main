import 'package:flutter/material.dart';
import 'package:greanspherproj/core/widget/validation.dart'; // <--- تأكد من صحة هذا المسار
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/SettingPage.dart'; // <--- استيراد SettingsScreen
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- استيراد ApiService

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key}); // أضف const constructor

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final ApiService _apiService = ApiService(); // إضافة ApiService

  final _formKey = GlobalKey<FormState>(); // مفتاح الفورم

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword() async {
    if (_formKey.currentState!.validate()) {
      // في ملف ChangePaswwordPage.dart
// ...
      try {
        await _apiService.changeUserPassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmNewPassword: _confirmNewPasswordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Password changed successfully! Please log in again.')), // رسالة للمستخدم
        );
        // مسح الـ Token الحالي (لو لم يتم مسحه)
        await ApiService.clearUserAuthToken(); // <--- إضافة هذا السطر

        // توجيه المستخدم إلى شاشة تسجيل الدخول ومسح كل الشاشات السابقة
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // <--- التوجيه لـ LoginScreen
          (Route<dynamic> route) => false, // مسح كل الـ routes السابقة
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password: ${e.toString()}')),
        );
        print("Error changing password: $e");
      }
    }
  }

  // دالة وهمية لتجنب خطأ الـ required في SettingsScreen (لأنها قد تكون استدعت من مكان غير ProfilePage)
  static void _dummyOnProfileUpdated() {
    print("Dummy onProfileUpdated called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text(
          "Change Password",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {}, // زر Edit/Save
              child: const Text(
                "Edit",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          // <--- إضافة Form
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              TextFormField(
                controller: _currentPasswordController,
                validator: MyValidation.validatePassword,
                obscureText: !_isCurrentPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  labelText: "Current password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                validator: MyValidation.validatePassword,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  labelText: "New password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmNewPasswordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirm new password is required';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return MyValidation.validatePassword(value);
                },
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  labelText: "Confirm New password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password must be at least 8 characters and should include:",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  const Text(". 1 uppercase letter (A-Z)",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 5),
                  const Text(". 1 lowercase letter (a-z)",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 5),
                  const Text(". 1 number (0-9)",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 5),
                  const Text(". 1 special character (@#\$%^&*+=.,?/)",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                              onProfileUpdated:
                                  () {})), // <--- التأكد من استدعاء ChatScreen
                    );
                  }, // <--- ربط بزر Submit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
