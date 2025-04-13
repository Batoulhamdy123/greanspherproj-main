import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
import 'package:greanspherproj/features/auth/register/controller/cubit/signupcubit_cubit.dart';
import 'package:greanspherproj/features/auth/verification/view/pages/verification.dart';
import 'package:greanspherproj/features/dashboard/view/dashboardpage.dart';

import '../../../../../core/utilities/app_assets.dart';
import '../../../../../core/utilities/color_manager.dart';
import '../../../../../core/utilities/custom_text_field.dart';
import '../../../../../core/utilities/dialog_utils.dart';
import '../../../../../core/utilities/validation.dart';
import '../../controller/cubit/signupcubit_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _obscureText2 = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenCubit, RegisterCubitState>(
        bloc: RegisterScreenCubit.get(context),
        listener: (context, state) {
          if (state is RegisterCubitLoadingState) {
            DialogUtils.showLoading(context: context, message: "Loading....");
          } else if (state is RegisterCubitErrorState) {
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
          } else if (state is RegisterCubitSuccessState) {
            DialogUtils.hideLoading(context);
            DialogUtils.showAlertDialog(
              context: context,
              title: "success",
              message: "Register Successfully",
            );
            Future.delayed(const Duration(seconds: 1)).then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DahboardPage()),
              );
              // Navigator.pushReplacementNamed(context, DahboardPage() as String);
            });
          }
        },
        child: Scaffold(
          backgroundColor: ColorManager.white,
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
                            "Sign Up ",
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
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "create an account to continue   ",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " First Name ",
                          controller: RegisterScreenCubit.get(context)
                              .firstNameController,
                          prefixIcon: const Icon(Icons.account_circle),
                          keyboardType: TextInputType.name,
                          validator: MyValidation.validateName,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " Last Name ",
                          controller: RegisterScreenCubit.get(context)
                              .lastNameController,
                          prefixIcon: const Icon(Icons.account_circle),
                          keyboardType: TextInputType.name,
                          validator: MyValidation.validateName,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " User Name ",
                          controller: RegisterScreenCubit.get(context)
                              .userNameController,
                          prefixIcon: const Icon(Icons.account_circle),
                          keyboardType: TextInputType.name,
                          validator: MyValidation.validateName,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " Email ",
                          controller:
                              RegisterScreenCubit.get(context).emailController,
                          prefixIcon: const Icon(Icons.email),
                          keyboardType: TextInputType.name,
                          validator: MyValidation.validateEmail,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " Password ",
                          controller: RegisterScreenCubit.get(context)
                              .passwordController,
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
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormFieldItem(
                          label: " Confirm Password ",
                          controller: RegisterScreenCubit.get(context)
                              .confirmPasswordController,
                          prefixIcon: const Icon(Icons.lock),
                          keyboardType: TextInputType.name,
                          validator: (val) =>
                              MyValidation.validateConfirmPassword(
                                  val,
                                  RegisterScreenCubit.get(context)
                                      .passwordController
                                      .text),
                          edgeInsetsGeometry:
                              const EdgeInsets.symmetric(vertical: 16.0),
                          obscureText: _obscureText2,
                          obscuringCharacter: '*',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              RegisterScreenCubit.get(context).register();
                            },
                            child: const Text(
                              "Sign Up ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          /*SizedBox(
                        height: AppSize.s60.h,
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomElevatedButton(
                          label: "Sign Up ",
                          backgroundColor: ColorManager.primary,
                          textStyle: getBoldStyle(
                              color: ColorManager.white, fontSize: 23),
                          onTap: () {
                            RegisterScreenCubit.get(context).register();
                          },
                        ),
                      ),*/
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
                        const SizedBox(height: 10),
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
                              child: Text('or sign up with'),
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
                                  child:
                                      Image.asset("assets/images/google.png")),
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "already have an account ? ",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              // Navigate to sign up screen

                              child: Text(
                                'Log in',
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
                ]),
          ),
        ));
  }
}
