import 'package:flutter/material.dart';
import 'package:greanspherproj/core/widget/validation.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  // TextEditingController newEmailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;

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
        title: Text(
          "Change Password",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            TextFormField(
              controller: currentPasswordController,
              validator: MyValidation.validateEmail,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.black54),
                labelText: "Current password",
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: currentPasswordController,
              validator: MyValidation.validatePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.black54),
                labelText: "new password",
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              validator: MyValidation.validatePassword,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.black54),
                labelText: "Confirm New password",
                border: UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password must be at least 8 characters and should include:",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(". 1 uppercase letter (A-Z)",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 5),
                Text(". 1 lowercase letter (a-z)",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 5),
                Text(". 1 number (0-9)",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 5),
                Text(". 1 special character (@#\$%^&*+=.,?/)",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
            SizedBox(height: 70),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
