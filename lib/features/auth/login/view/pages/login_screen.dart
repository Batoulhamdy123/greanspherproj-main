import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/auth/login/controller/cubit/logincubit_cubit.dart';

import '../../../../../core/resource/app_assets.dart';
import '../../../../../core/routes_manger/routes.dart';
import '../../../../../core/widget/custom_text_field.dart';
import '../../../../../core/widget/dialog_utils.dart';
import '../../../../../core/widget/validation.dart';
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

          DialogUtils.showMessage(
            context: context,
            title: "Error",
            message: state.failures.errorMessage,
          );
          Future.delayed(const Duration(seconds: 1)).then((_) {
            Navigator.of(context).pop();
          });
        } else if (state is LoginCubitSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            title: "success",
            message: "Login Successfully",
          );
          // Future.delayed(const Duration(seconds: 1)).then((_) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => Verfication()),
          //   );
          //   // Navigator.pushReplacementNamed(context, Verfication() as String);
          // });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Please sign in to continue   ",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                          Navigator.pushNamed(context, Routes.forgetPassword);
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          LoginScreenCubit.get(context).login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Log In ",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 19, 81, 132),
                            size: 47,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                          },
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset("assets/images/google.png")),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.signupRoute);
                          },
                          child: const Text(
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
