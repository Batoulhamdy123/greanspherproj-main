import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/home_screen.dart';

import '../../../../core/widget/custom_text_field.dart';
import '../../../../core/widget/dialog_utils.dart';
import '../../../../core/widget/imageforget.dart';
import '../../../../core/widget/validation.dart';
import '../../confirm_email_code/view/pages/confirm_email_screen.dart';
import '../controller/cubit/send_confirm_email_code_screen_cubit.dart';
import '../controller/cubit/send_confirm_email_code_screen_state.dart';

class SendConfirmEmailScreen extends StatelessWidget {
  const SendConfirmEmailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendConfirmEmailCodeScreenCubit,
        SendConfirmEmailCodeScreenState>(
      bloc: SendConfirmEmailCodeScreenCubit.get(context),
      listener: (context, state) {
        if (state is SendConfirmEmailCodeLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is SendConfirmEmailCodeErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.of(context).pop();
          });
        } else if (state is SendConfirmEmailCodeSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "success",
            message:
                "The confirmation email code has been sent to your email successfully. Check your inbox.",
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmEmailScreen(
                  provider: "gmail",
                  email: SendConfirmEmailCodeScreenCubit.get(context)
                      .emailController
                      .text
                      .trim(),
                  fromScreen: 'SendConfirmEmailScreen',
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
                    "Verify Email",
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
                    "Enter the email address you used when you joined and we'll send you instruction to Verify Email .  ",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldItem(
                  label: "email",
                  controller: SendConfirmEmailCodeScreenCubit.get(context)
                      .emailController,
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.name,
                  validator: MyValidation.validateEmail,
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      SendConfirmEmailCodeScreenCubit.get(context)
                          .sendConfirmEmailCode('gmail');
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
