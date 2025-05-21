import 'package:flutter/material.dart';

import '../../core/resource/app_assets.dart';
import '../../core/routes_manger/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Routes.signInRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Image.asset(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            AppAssets.splashScreen));
  }
}
