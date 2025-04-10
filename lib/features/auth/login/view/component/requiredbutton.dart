// import 'package:greanspherproj/features/auth/changepassword/view/pages/changepass.dart';
// import 'package:greanspherproj/features/auth/forgetpassword/controller/cubit/forgetpassword_cubit.dart';
// import 'package:greanspherproj/features/auth/forgetpassword/view/forgetpage.dart';
// import 'package:greanspherproj/features/auth/login/controller/cubit/logincubit_cubit.dart';
// import 'package:greanspherproj/features/auth/login/view/component/textfields.dart';
// import 'package:greanspherproj/features/auth/verification/view/pages/verification.dart';
// import 'package:flutter/material.dart';
//
// import '../../../register/controller/cubit/signupcubit_cubit.dart';
// import '../../../register/view/pages/register_screen.dart';
//
// class RequiredButton extends StatelessWidget {
//   RequiredButton(
//       {super.key, required this.controller, required this.controller2});
//   final LogincubitCubit controller;
//   final RegisterScreenCubit controller2;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Text(
//                 "Log In ",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 27,
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50),
//               child: Text(
//                 "Please sign in to continue   ",
//                 style: TextStyle(fontSize: 15),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFields(
//                 controller: controller,
//               ),
//             ),
//             const SizedBox(height: 7),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ForgetPage(
//                               controller: ForgetpasswordCubit(),
//                               label: " Forget Password",
//                               label2: "reset your password ",
//                               button: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => Verfication(
//                                                 button: ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               ChangePass(
//                                                                 controller2:
//                                                                     controller2,
//                                                               )),
//                                                     );
//                                                   },
//                                                   child: const Text(
//                                                     "Verify Code  ",
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 23),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                   style:
//                                                       ElevatedButton.styleFrom(
//                                                     backgroundColor:
//                                                         Colors.green,
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 100,
//                                                         vertical: 10),
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10.0),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 word: "Verify Code Send ",
//                                               )));
//                                 },
//                                 child: const Text(
//                                   "Send Code   ",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 23),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 100, vertical: 10),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                               ),
//                             )),
//                   );
//                 },
//                 child: const Text(
//                   'Forgot Password ?',
//                   style: TextStyle(color: Colors.green),
//                 ),
//               ),
//             ),
//             /*Padding(
//           padding: EdgeInsets.symmetric( 283, 533, 45, 382),
//           child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 "Forget Password ",
//                 style: TextStyle(color: Colors.green, fontSize: 23),
//               )),
//         ),*/
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text(
//                   "Log In ",
//                   style: TextStyle(color: Colors.white, fontSize: 23),
//                   textAlign: TextAlign.center,
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ),
//             /*
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               primary: Colors.green,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: Text('Log in'),
//           ),
//         ),*/
//             const SizedBox(height: 20),
//             const Row(
//               children: [
//                 Expanded(
//                     child: Divider(
//                   indent: 15,
//                   color: Colors.grey,
//                   thickness: 1.0,
//                 )),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text('or sign in with'),
//                 ),
//                 Expanded(
//                     child: Divider(
//                   endIndent: 15,
//                   color: Colors.grey,
//                   thickness: 1.0,
//                 )),
//               ],
//             ),
//             SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.facebook,
//                     color: Color.fromARGB(255, 19, 81, 132),
//                     size: 47,
//                   ),
//                   onPressed: () {},
//                 ),
//                 SizedBox(width: 30),
//                 GestureDetector(
//                   onTap: () {
//                     // Google login action
//                   },
//                   child: Container(
//                       height: 40,
//                       width: 40,
//                       child: Image.asset("assets/images/google.png")),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Don't have an account? ",
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignUp()),
//                     );
//                   },
//                   // Navigate to sign up screen
//
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                 ),
//                 //Padding(padding: EdgeInsets.fromLTRB(45, 738.11, 35, 110),child: ,)
//               ],
//             ),
//           ]),
//     );
//   }
// }
