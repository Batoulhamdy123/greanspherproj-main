import 'package:flutter/material.dart';
import 'package:greanspherproj/core/routes_manger/routes.dart';
import 'package:greanspherproj/features/auth/forgetpassword/view/forget_password_screen.dart';
import 'package:greanspherproj/features/auth/send_confirm_email_code/view/send_confirm_email_screen.dart';

import '../../features/auth/login/view/pages/login_screen.dart';
import '../../features/auth/register/view/pages/register_screen.dart';
import '../../features/splash_screen/splash_screen.dart';
import '../resource/color_manager.dart';
import '../resource/constant_manager.dart';
import '../resource/font_manger.dart';
import '../resource/style_manger.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      // case Routes.cartRoute:
      //   return MaterialPageRoute(builder: (_) => const CartScreen());
      case Routes.confirmEmail:
        return MaterialPageRoute(
            builder: (_) => const SendConfirmEmailScreen());
      case Routes.forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case Routes.signInRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signupRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                backgroundColor: ColorManager.primary,
                title: Text(AppConstants.unDefinedRoute,
                    style: getBoldStyle(
                        color: ColorManager.white, fontSize: FontSize.s20)),
              ),
              body: Center(
                child: Text(AppConstants.unDefinedRoute,
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s20)),
              ),
            ));
  }
}
