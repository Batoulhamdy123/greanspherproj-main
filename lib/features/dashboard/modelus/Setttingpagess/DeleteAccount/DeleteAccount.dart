import 'package:flutter/material.dart';
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart'; // <--- استيراد ApiService
// تحتاج لاستيراد شاشة تسجيل الدخول (استبدل المسار بالمسار الصحيح لشاشة تسجيل الدخول لديك)
//import 'package:greanspherproj/features/LoginScreen/view/LoginScreen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart'; // <--- مثال: افترض أن شاشة تسجيل الدخول اسمها LoginScreen

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isChecked = false; // Checkbox state
  final ApiService _apiService = ApiService(); // <--- إضافة ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Delete account",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delete your account?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deleting your account removes all your GreenSphere account information, including GreenSphere credit and rewards points. You won’t be able to get your data back.",
              style: TextStyle(fontSize: 17, color: Colors.black87),
            ),
            const SizedBox(height: 299), // مسافة كافية لدفع المحتوى لأسفل
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                ),
                const Expanded(
                  child: Text(
                    "I understand that this will remove my GreenSphere credit and rewards points",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(
                      context); // الرجوع للشاشة السابقة (Account Info)
                },
                child: const Text(
                  "Keep account",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isChecked
                    ? () async {
                        // <--- زرار حذف الحساب
                        try {
                          // لا نظهر showDialog للتأكيد هنا، لأننا نعتمد على الـ Checkbox
                          await _apiService
                              .deleteUserAccount(); // <--- استدعاء API حذف الحساب
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Account deleted successfully!')),
                          );
                          // توجيه المستخدم إلى شاشة تسجيل الدخول ومسح كل الشاشات السابقة
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen()), // <--- استبدل LoginScreen بشاشتك
                            (Route<dynamic> route) =>
                                false, // مسح كل الـ routes السابقة
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to delete account: ${e.toString()}')),
                          );
                          print("Error deleting account: $e");
                        }
                      }
                    : null, // الزرار معطل لو الـ Checkbox مش معلم
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: isChecked
                      ? Colors.black
                      : Colors.grey, // لون النص بناءً على isChecked
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Delete account"),
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
