import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/core/resource/context.dart';
import 'package:greanspherproj/features/auth/forgetpassword/controller/cubit/forget_password_screen_cubit.dart';
import 'package:greanspherproj/features/auth/reset_password/pages/reset_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/widget/dialog_utils.dart';
import '../../../../../core/widget/imageforget.dart';
import '../../controller/cubit/confirm_email_code_cubit.dart';
import '../../controller/cubit/confirm_email_code_state.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;
  final String provider;
  final String fromScreen;

  const ConfirmEmailScreen({
    super.key,
    required this.email,
    required this.provider,
    required this.fromScreen,
  });

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  void initState() {
    super.initState();
    ConfirmEmailCodeCubit.get(context).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    String enteredCode = '';

    return BlocConsumer<ConfirmEmailCodeCubit, ConfirmEmailCodeState>(
        bloc: ConfirmEmailCodeCubit.get(context),
      listener: (context, state) {
        if (state is ConfirmEmailCodeLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is ConfirmEmailCodeErrorState) {
          DialogUtils.hideLoading(context);

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
            message: "The operation was completed successfully..",
            );
            Future.delayed(const Duration(seconds: 1)).then((_) {
              if (widget.fromScreen == 'SendConfirmEmailScreen') {
                // Navigator.push(
                //   context,
                //   // MaterialPageRoute(builder: (context) => LoginSuccessScreen()),
                // );
              } else if (widget.fromScreen == 'ForgetPasswordScreen') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(
                          email: ForgetPasswordScreenCubit.get(context)
                              .emailController
                              .text
                              .trim(),
                          code: ConfirmEmailCodeCubit.get(context)
                              .pinCodeController
                              .text
                              .trim())),
                );
              }
            });
          }
      },
        builder: (context, state) {
          int counter = 60;

          if (state is ConfirmEmailCodeTimerTick) {
            counter = state.counter;
          }
          child:
          return Scaffold(
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
                        selectedFillColor: Colors.black,
                        fieldOuterPadding:
                                EdgeInsets.only(right: context.width / 30)),
                        cursorColor: Colors.white,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,

                    controller: ConfirmEmailCodeCubit.get(context)
                            .pinCodeController,
                        keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 20,
                      )
                    ],
                        onChanged: (value) {
                          setState(() {
                            enteredCode = value;
                          });
                        },
                        onCompleted: (code) {
                          ConfirmEmailCodeCubit.get(context)
                              .sendConfirmEmailCode(
                            widget.provider,
                            widget.email,
                          );
                        },
                        beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                Center(
                      child: BlocBuilder<ConfirmEmailCodeCubit,
                          ConfirmEmailCodeState>(
                        builder: (context, state) {
                          int counter =
                              ConfirmEmailCodeCubit.get(context).counter;
                          if (state is ConfirmEmailCodeTimerTick) {
                            counter = state.counter;
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "00:${counter.toString().padLeft(2, '0')} sec",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: counter == 0
                                    ? () {
                                        ConfirmEmailCodeCubit.get(context)
                                            .resetTimer();
                                        if (widget.fromScreen ==
                                            'ForgetPasswordScreen') {
                                          ForgetPasswordScreenCubit.get(context)
                                              .emailController
                                              .text = widget.email;
                                          ForgetPasswordScreenCubit.get(context)
                                              .forgetPasswordConfirmEmailCode(
                                                  widget.provider);
                                        } else if (widget.fromScreen ==
                                            'SendConfirmEmailScreen') {
                                          ConfirmEmailCodeCubit.get(context)
                                              .sendConfirmEmailCode(
                                                  widget.provider,
                                                  widget.email);
                                        }
                                        // ForgetPasswordScreenCubit.get(context).emailController.text = widget.email;
                                        // ForgetPasswordScreenCubit.get(context).forgetPasswordConfirmEmailCode(widget.provider);
                                      }
                                    : null,
                                child: const Text(
                                  'Send Again',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmEmailCodeCubit.get(context)
                              .sendConfirmEmailCode(
                                  widget.provider, widget.email);
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
                    onPressed: () {},
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
              ));
        });
  }
}
