import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/custom_text_field.dart';
import '../../../../core/widget/dialog_utils.dart';
import '../../../../core/widget/imageforget.dart';
import '../../../../core/widget/validation.dart';
import '../../confirm_email_code/view/pages/confirm_email_screen.dart';
import '../controller/cubit/forget_password_screen_cubit.dart';
import '../controller/cubit/forget_password_screen_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordScreenCubit, ForgetPasswordScreenState>(
      bloc: ForgetPasswordScreenCubit.get(context),
      listener: (context, state) {
        if (state is ForgetPasswordLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is ForgetPasswordErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.of(context).pop();
          });
        } else if (state is ForgetPasswordSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "success",
            message: "The operation was completed successfully.",
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmEmailScreen(
                  provider: "gmail",
                  email: ForgetPasswordScreenCubit.get(context)
                      .emailController
                      .text
                      .trim(),
                  fromScreen: 'ForgetPasswordScreen',
                ),
              ),
            );
          });
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ForgetImage(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "Forgot Password",
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
                    "Enter the email address you used when you joined and we'll send you instruction to reset your password .  ",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldItem(
                  label: "email",
                  controller:
                      ForgetPasswordScreenCubit.get(context).emailController,
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.name,
                  validator: MyValidation.validateEmail,
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ForgetPasswordScreenCubit.get(context)
                          .forgetPasswordConfirmEmailCode('gmail');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Send Code   ",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )),
    );
  }
}
