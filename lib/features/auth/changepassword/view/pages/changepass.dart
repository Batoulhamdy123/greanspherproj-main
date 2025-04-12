// import 'package:greanspherproj/features/auth/changepassword/view/component/customwidget.dart';
// import 'package:greanspherproj/features/auth/forgetpassword/view/imageforget.dart';
// import 'package:greanspherproj/features/auth/login/view/pages/login_screen.dart';
// import 'package:flutter/material.dart';
// import '../../../register/controller/cubit/signupcubit_cubit.dart';
//
// class ChangePass extends StatelessWidget {
//   final RegisterScreenCubit controller2;
//   const ChangePass({
//     super.key,
//     required this.controller2,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: Icon(Icons.arrow_back),
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const ForgetImage(),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//               child: Text(
//                 "New Password  ",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 25,
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Text(
//                 "Enter New Password  ",
//                 style: TextStyle(fontSize: 15),
//               ),
//             ),
//             CustomWidget(
//               hint_text: "Password",
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             CustomWidget(
//               hint_text: "Confirm Password ",
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//                 child: const Text(
//                   "Create New Password ",
//                   style: TextStyle(color: Colors.white, fontSize: 15),
//                   textAlign: TextAlign.center,
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 80, vertical: 17),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
