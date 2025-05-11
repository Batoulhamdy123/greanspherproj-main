import 'package:flutter/material.dart';
import '../../../../core/widget/custom_text_field.dart';
import '../../../../core/widget/imageforget.dart';

class ConfirmEmail extends StatelessWidget {
  ConfirmEmail({
    super.key,
    this.controller,
    this.screenName,
    this.label,
    this.button,
  });

  final TextEditingController? controller;

  final String? screenName;
  final String? label;
  final Widget? button;
  Widget? button1;

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  screenName!,
                  style: const TextStyle(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Enter the email address you used when you  joined and we'll send you instruction to $label .  ",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: TextFormField(
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     // controller: controller.emailControllerfor,
              //     keyboardType: TextInputType.text,
              //     validator: MyValidation.validateEmail,
              //
              //     /* inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //       RegExp(r'^(\+20|015|011|010)\d{9}$')),
              //   // FilteringTextInputFormatter.deny(RegExp(r'(A-Z)'))
              // ],*/
              //     decoration: decoration.copyWith(
              //       suffixIcon: const Icon(Icons.email),
              //       // hintText: "Email",
              //       contentPadding: const EdgeInsets.symmetric(
              //         vertical: 16.0,
              //       ),
              //     ),
              //   ),
              // ),
              TextFormFieldItem(
                label: "email",
                controller: controller!,
              ),
              const SizedBox(height: 50),
              Center(
                child: button,
                // ElevatedButton(
                //   onPressed: () {},
                //   child: const Text(
                //     "Send Code   ",
                //     style: TextStyle(color: Colors.white, fontSize: 23),
                //     textAlign: TextAlign.center,
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.green,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 100, vertical: 10),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                // ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(child: button1 ?? Container()),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Having  a Problem ? ",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Send Again ',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(45, 738.11, 35, 110),child: ,)
                ],
              ),*/
            ],
          ),
        ));
  }

// InputDecoration decoration = const InputDecoration();
}
