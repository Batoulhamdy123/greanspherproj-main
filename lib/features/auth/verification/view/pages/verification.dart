//import 'package:greanspherproj/features/auth/changepassword/view/pages/changepass.dart';
import 'package:greanspherproj/features/auth/forgetpassword/view/imageforget.dart';
import 'package:greanspherproj/features/auth/verification/view/component/requiredfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class Verfication extends StatelessWidget {
  Verfication({
    super.key,
    required this.button,
    required this.word,
    this.button1,
  });
  final Widget button;
  int counter = 60;
  final String word;

  Widget? button1;

  //String character1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /* SizedBox(
                height: 10,
              ),*/
              ForgetImage(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  word,
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
              SizedBox(
                height: 10,
              ),
              RequiredFeild(),
              // const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "00: $counter sec",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 3,
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
                    //Padding(padding: EdgeInsets.fromLTRB(45, 738.11, 35, 110),child: ,)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: button,
                /* ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePass()),
                    );
                  },
                  child: const Text(
                    "Verify Code  ",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),*/
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: button1 ?? Container())
              /*TextButton(
                onPressed: () {},
                child: Text(
                  character1,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),*/
            ],
          ),
        ));
  }

  InputDecoration decoration = InputDecoration();
}
