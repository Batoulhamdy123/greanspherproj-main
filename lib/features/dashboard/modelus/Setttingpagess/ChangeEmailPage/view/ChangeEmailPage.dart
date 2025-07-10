import 'package:flutter/material.dart';
import 'package:greanspherproj/core/widget/validation.dart'; // <--- تأكد من صحة هذا المسار
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangeEmailPage/verichangeemail.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _currentEmailController =
      TextEditingController(); // تم تغيير الاسم
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController(); // تم تغيير الاسم
  bool _isPasswordVisible = false;
  bool _isEditing = false; // <--- إضافة هذا السطر الجديد لتعريف _isEditing
  final ApiService _apiService = ApiService();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  void _submitChangeEmail() async {
    if (_formKey.currentState!.validate()) {
      // في ملف ChangeEmailPage.dart
// ...
      try {
        await _apiService.changeUserEmail(
          newEmail: _newEmailController.text,
          currentPassword: _currentPasswordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Verification code sent to your new email!')),
        );
        // مهم جداً: مسح الـ Token الحالي، لأن الـ Backend قد يكون ألغى صلاحيته
        await ApiService.clearUserAuthToken(); // <--- إضافة هذا السطر

        // التوجيه إلى صفحة التحقق من الإيميل مع تمرير الإيميل الجديد
        // Navigator.pushReplacement هنا عشان نمسح ChangeEmailScreen من الـ stack
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyChangeEmailScreen(
              newEmail: _newEmailController.text,
            ),
          ),
        );
      } catch (e) {
// ... catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change email: ${e.toString()}')),
        );
        print("Error changing email: $e");
      }
    }
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
          "Change Email",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                // هنا يجب أن يكون الزرار Save/Edit
                if (_isEditing) {
                  // لو في وضع التعديل، يبقى زر Save
                  _submitChangeEmail(); // حفظ التغييرات
                }
                setState(() {
                  _isEditing = !_isEditing; // تبديل وضع التعديل
                });
              },
              child: Text(
                _isEditing ? "Save" : "Edit", // النص "Save" أو "Edit"
                style: TextStyle(color: Colors.green, fontSize: 20), // لون النص
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              TextFormField(
                controller: _currentEmailController,
                validator: MyValidation.validateEmail,
                obscureText: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.black54),
                  labelText: "Current Email",
                  border: UnderlineInputBorder(),
                ),
                enabled:
                    _isEditing, // <--- تفعيله أو تعطيله بناءً على _isEditing
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newEmailController,
                validator: MyValidation.validateEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.black54),
                  labelText: "Confirm new email",
                  border: UnderlineInputBorder(),
                ),
                enabled:
                    _isEditing, // <--- تفعيله أو تعطيله بناءً على _isEditing
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _currentPasswordController,
                validator: MyValidation.validatePassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  labelText: "Current password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                enabled:
                    _isEditing, // <--- تفعيله أو تعطيله بناءً على _isEditing
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isEditing
                      ? _submitChangeEmail
                      : null, // <--- الزرار يكون شغال بس لو _isEditing True
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
