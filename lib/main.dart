import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greanspherproj/di/di.dart';
import 'package:greanspherproj/features/auth/register/controller/cubit/signupcubit_cubit.dart';
import 'core/bloc_observer/bloc_observer.dart';
import 'core/routes_manger/routes.dart';
import 'core/routes_manger/routes_generator.dart';
import 'features/auth/login/controller/cubit/logincubit_cubit.dart';
import 'features/auth/send_confirm_email_code/controller/cubit/send_confirm_email_code_screen_cubit.dart';

void main() {
  configureDependencies();
  Bloc.observer = MyBlocObserver();
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<RegisterScreenCubit>()),
        BlocProvider(create: (context) => getIt<LoginScreenCubit>()),
        BlocProvider(
            create: (context) => getIt<SendConfirmEmailCodeScreenCubit>()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            home: child,
            initialRoute: Routes.splashScreenRoute,
            onGenerateRoute: RouteGenerator.getRoute,
          );
        });
  }
}
