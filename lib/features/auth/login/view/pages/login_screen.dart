import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/auth/login/controller/cubit/logincubit_cubit.dart';

import '../../../../../core/utilities/app_assets.dart';
import '../../../../../core/utilities/custom_text_field.dart';
import '../../../../../core/utilities/dialog_utils.dart';
import '../../../../../core/utilities/validation.dart';
import '../../../forgetpassword/controller/cubit/forgetpassword_cubit.dart';
import '../../../forgetpassword/view/forgetpage.dart';
import '../../../register/view/pages/register_screen.dart';
import '../../../verification/view/pages/verification.dart';
import '../../controller/cubit/logincubit_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenCubit, LoginCubitState>(
      bloc: LoginScreenCubit.get(context),
      listener: (context, state) {
        if (state is LoginCubitLoadingState) {
          DialogUtils.showLoading(context: context, message: "Loading....");
        } else if (state is LoginCubitErrorState) {
          DialogUtils.hideLoading(context);
          // if (state.failures is ValidationFailure) {
          //   final validationErrors =
          //       (state.failures as ValidationFailure).errors;
          //   DialogUtil.showAlertDialog(
          //     context: context,
          //     title: "Validation Errors",
          //     message: validationErrors.join("\n"),
          //   );
          // } else {
          DialogUtils.showAlertDialog(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
          // }
          // Future.delayed(const Duration(seconds: 1)).then((_) {
          //   Navigator.of(context).pop();
          // });
        } else if (state is LoginCubitSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showAlertDialog(
            context: context,
            title: "success",
            message: "Register Successfully",
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.pushReplacementNamed(context, Verfication() as String);
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        AppAssets.loginScreen,
                        height: 160,
                        width: 180,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Log In ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 27,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Please sign in to continue   ",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextFormFieldItem(
                      label: " Email ",
                      controller: LoginScreenCubit.get(context).emailController,
                      prefixIcon: const Icon(Icons.account_circle),
                      keyboardType: TextInputType.name,
                      validator: MyValidation.validateEmail,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormFieldItem(
                      label: " Password ",
                      controller:
                          LoginScreenCubit.get(context).passwordController,
                      prefixIcon: const Icon(Icons.lock),
                      keyboardType: TextInputType.name,
                      validator: MyValidation.validatePassword,
                      edgeInsetsGeometry:
                          const EdgeInsets.symmetric(vertical: 16.0),
                      obscureText: _obscureText,
                      obscuringCharacter: '*',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPage(
                                      controller: ForgetpasswordCubit(),
                                      label: " Forget Password",
                                      label2: "reset your password ",
                                      button: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Verfication(
                                                      // button: ElevatedButton(
                                                      //   onPressed: () {
                                                      //     // Navigator.push(
                                                      //     //   context,
                                                      //     //   MaterialPageRoute(
                                                      //     //       builder:
                                                      //     //           (context) =>
                                                      //     //           ChangePass(
                                                      //     //             controller2:
                                                      //     //             controller2,
                                                      //     //           )
                                                      //     //   ),
                                                      //     // );
                                                      //   },
                                                      //   child: const Text(
                                                      //     "Verify Code  ",
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .white,
                                                      //         fontSize: 23),
                                                      //     textAlign: TextAlign
                                                      //         .center,
                                                      //   ),
                                                      //   style: ElevatedButton
                                                      //       .styleFrom(
                                                      //     backgroundColor:
                                                      //         Colors.green,
                                                      //     padding:
                                                      //         const EdgeInsets
                                                      //             .symmetric(
                                                      //             horizontal:
                                                      //                 100,
                                                      //             vertical:
                                                      //                 10),
                                                      //     shape:
                                                      //         RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(
                                                      //                   10.0),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // word:
                                                      //     "Verify Code Send ",
                                                      )));
                                        },
                                        child: const Text(
                                          "Send Code   ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 23),
                                          textAlign: TextAlign.center,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 100, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    )),
                          );
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    /*Padding(
                padding: EdgeInsets.symmetric( 283, 533, 45, 382),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forget Password ",
                      style: TextStyle(color: Colors.green, fontSize: 23),
                    )),
              ),*/
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          LoginScreenCubit.get(context).login();
                        },
                        child: const Text(
                          "Log In ",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    /*
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Log in'),
                ),
              ),*/
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                            child: Divider(
                          indent: 15,
                          color: Colors.grey,
                          thickness: 1.0,
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or sign in with'),
                        ),
                        Expanded(
                            child: Divider(
                          endIndent: 15,
                          color: Colors.grey,
                          thickness: 1.0,
                        )),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 19, 81, 132),
                            size: 47,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            // Google login action
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset("assets/images/google.png")),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          // Navigate to sign up screen

                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        //Padding(padding: EdgeInsets.fromLTRB(45, 738.11, 35, 110),child: ,)
                      ],
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
