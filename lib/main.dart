import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greanspherproj/di/di.dart';
import 'package:greanspherproj/features/auth/register/controller/cubit/signupcubit_cubit.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/home_screen.dart';
import 'package:greanspherproj/features/dashboard/view/dashboardpage.dart';

import 'core/bloc_observer/bloc_observer.dart';
import 'features/auth/register/view/pages/register_screen.dart';

void main() {
  configureDependencies();
  Bloc.observer = MyBlocObserver();
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<RegisterScreenCubit>()),
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
        builder: (_, child) {
          return MaterialApp(
            // useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            home: DahboardPage(),
          );
        });
  }
}
