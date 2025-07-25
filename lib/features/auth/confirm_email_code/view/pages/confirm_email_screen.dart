import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/core/resource/context.dart';
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
import 'package:greanspherproj/features/auth/reset_password/pages/reset_password_screen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/ComponentPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/home_screen.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/ChangeEmailPage/view/ChangeEmailPage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/widget/dialog_utils.dart';
import '../../../../../core/widget/imageforget.dart';
import '../../controller/cubit/confirm_email_code_cubit.dart';
import '../../controller/cubit/confirm_email_code_state.dart';
import 'dart:async';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;
  final String provider;
  final String fromScreen;

  ConfirmEmailScreen({
    super.key,
    required this.email,
    required this.provider,
    required this.fromScreen,
  });

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  int _counter = 60;
  Timer? _timer;
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfirmEmailCodeCubit, ConfirmEmailCodeState>(
      bloc: ConfirmEmailCodeCubit.get(context),
      listener: (context, state) {
        if (state is ConfirmEmailCodeLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is ConfirmEmailCodeErrorState) {
          DialogUtils.hideLoading(context);
          print(
              "Error occurred: ${state.failures.errorMessage}"); // Displaying error in console

          DialogUtils.showMessage(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
        } else if (state is ConfirmEmailCodeSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "success",
            message:
                "The confirmation email code has been sent to your email successfully. Check your inbox.",
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            if (widget.fromScreen == 'ForgetPasswordScreen') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPasswordScreen(
                    email: widget.email,
                    code: ConfirmEmailCodeCubit.get(context).pinCodeController,
                  ),
                ),
              );
            } else if (widget.fromScreen == 'SendConfirmEmailScreen') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
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
                    "Verify code send ",
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
                    "Enter 6-digits code sent to your email   ",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                    obscureText: true,
                    obscuringCharacter: '*',
                    // obscuringWidget: const FlutterLogo(
                    //   size: 24,
                    // ),
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "I'm from validator";
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
                        selectedFillColor:
                            const Color.fromARGB(255, 241, 238, 238),
                        fieldOuterPadding:
                            EdgeInsets.only(right: context.width / 30)),
                    cursorColor: Colors.white,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController ,

                    controller:
                        ConfirmEmailCodeCubit.get(context).pinCodeController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Color.fromARGB(243, 225, 222, 222),
                        blurRadius: 20,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    // onChanged: (value) {
                    //   debugPrint(value);
                    //   setState(() {
                    //    currentText = value;
                    //   }
                    //   );
                    // },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "00: ${_counter.toString().padLeft(2, '0')} sec",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      TextButton(
                        onPressed: () {},
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
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmEmailCodeCubit.get(context)
                          .sendConfirmEmailCode(widget.provider, widget.email);
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
                      "Verify Code  ",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangeEmailScreen()), // <--- التأكد من استدعاء ChatScreen
                      );
                    },
                    child: const Text(
                      "Change Email ",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  InputDecoration decoration = const InputDecoration();
}
