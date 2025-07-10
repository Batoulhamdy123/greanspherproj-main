import 'package:flutter/material.dart';
import 'package:greanspherproj/core/resource/context.dart'; // تأكد من صحة هذا المسار
import 'package:greanspherproj/core/widget/imageforget.dart'; // تأكد من صحة هذا المسار
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/view/SettingPage.dart'; // <--- استيراد SettingsScreen
import 'package:pin_code_fields/pin_code_fields.dart'; // PinCodeTextField
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- استيراد ApiService

class VerifyChangeEmailScreen extends StatefulWidget {
  // <--- تم تغييرها لـ StatefulWidget
  final String newEmail; // <--- تستقبل الإيميل الجديد

  const VerifyChangeEmailScreen(
      {super.key, required this.newEmail}); // <--- Constructor جديد

  @override
  State<VerifyChangeEmailScreen> createState() =>
      _VerifyChangeEmailScreenState();
}

class _VerifyChangeEmailScreenState extends State<VerifyChangeEmailScreen> {
  final TextEditingController _pinCodeController =
      TextEditingController(); // Controller لـ PinCode
  final ApiService _apiService = ApiService(); // إضافة ApiService

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  void _verifyCode() async {
    final code = _pinCodeController.text;
    if (code.length != 6) {
      // تأكد أن الكود 6 أرقام
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit code.')),
      );
      return;
    }
// في ملف verichangeemail.dart
// ...
    try {
      final responseEmail = await _apiService.verifyChangeEmail(code: code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Email changed successfully to: $responseEmail. Please log in again.')), // رسالة للمستخدم
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
// ... catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify code: ${e.toString()}')),
      );
      print("Error verifying code: $e");
    }
  }

  // دالة وهمية لتجنب خطأ الـ required في SettingsScreen (لأنها قد تكون استدعت من مكان غير ProfilePage)
  static void _dummyOnProfileUpdated() {
    print("Dummy onProfileUpdated called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ForgetImage(), // <--- تأكد من وجود Widget ده
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Verify code sent to ${widget.newEmail}", // عرض الإيميل الجديد
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter 6-digits code sent to your email",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                appContext: context,
                pastedTextStyle: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false, // الكود غالباً لا يكون مخفي
                // obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length != 6) {
                    return "Please enter a 6-digit code";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: const BorderRadius.all(Radius.circular(
                      12,
                    )),
                    fieldHeight: 45,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    selectedFillColor: Colors.grey.shade200,
                    fieldOuterPadding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width /
                            30)), // استخدام MediaQuery
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 20,
                  )
                ],
                onCompleted: (v) {
                  debugPrint("Completed: $v");
                  _verifyCode(); // استدعاء التحقق عند اكتمال الكود
                },
                onChanged: (value) {
                  _pinCodeController.text = value; // تحديث الـ controller
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  return true;
                },
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "60 sec", // TODO: ممكن تعمل timer هنا
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3),
                  TextButton(
                    onPressed: () {
                      // TODO: إعادة إرسال الكود
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resend code (Dummy)')),
                      );
                    },
                    child: const Text(
                      'Send Again ',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                            onProfileUpdated:
                                () {})), // <--- التأكد من استدعاء ChatScreen
                  );
                },
                // <--- ربط بزر Verify Code
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Verify Code",
                  style: TextStyle(color: Colors.white, fontSize: 23),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
