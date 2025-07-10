import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/core/widget/validation.dart';
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
import 'package:greanspherproj/features/auth/reset_password/controller/cubit/reset_password_state.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/ComponentPage.dart';
import 'package:greanspherproj/features/dashboard/view/dashboardpage.dart';

import '../../../../../core/widget/custom_text_field.dart';
import '../../../../../core/widget/imageforget.dart';
import '../../../../core/widget/dialog_utils.dart';
import '../controller/cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final dynamic code;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureText = true;
  bool _obscureText2 = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      bloc: ResetPasswordCubit.get(context),
      listener: (context, state) {
        if (state is ResetPasswordLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is ResetPasswordErrorState) {
          DialogUtils.hideLoading(context);

          DialogUtils.showMessage(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
        } else if (state is ResetPasswordSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "success",
            message: "The operation was completed successfully..",
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            // Navigator.pushReplacementNamed(context, Verification() as String);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ForgetImage(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "New Password  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Enter New Password  ",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextFormFieldItem(
                  label: "Password",
                  controller: ResetPasswordCubit.get(context).newPassword,
                  prefixIcon: const Icon(Icons.lock),
                  keyboardType: TextInputType.name,
                  validator: MyValidation.validatePassword,
                  edgeInsetsGeometry:
                      const EdgeInsets.symmetric(vertical: 16.0),
                  obscureText: _obscureText,
                  obscuringCharacter: '*',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormFieldItem(
                  label: "Confirm Password ",
                  controller: ResetPasswordCubit.get(context).confirmPassword,
                  prefixIcon: const Icon(Icons.lock),
                  keyboardType: TextInputType.name,
                  validator: MyValidation.validatePassword,
                  edgeInsetsGeometry:
                      const EdgeInsets.symmetric(vertical: 16.0),
                  obscureText: _obscureText,
                  obscuringCharacter: '*',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = _obscureText2;
                      });
                    },
                  )),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen()), // <--- التأكد من استدعاء ChatScreen
                    );
                    //ResetPasswordCubit.get(context)
                    // .resetPassword(widget.email, widget.code);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Create New Password ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
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
