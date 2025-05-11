import 'package:greanspherproj/core/resource/context.dart';
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/auth/verification/controller/cubit/vericationcubit_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RequiredField extends StatelessWidget {
  const RequiredField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            selectedFillColor: Colors.black,
            fieldOuterPadding: EdgeInsets.only(right: context.width / 30)),
        cursorColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        // errorAnimationController: errorController ,

        controller: VerficationcubitCubit().pinCodeController,
        keyboardType: TextInputType.number,
        boxShadows: const [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black12,
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
    );
  }
}
