import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/Setting/controller/cubit/settingcubit_cubit.dart';

class Customlisttile extends StatelessWidget {
  final String title;
  final Widget? page;
  final bool isBottomSheet;
  final String? type;
  final String? subtitle;

  const Customlisttile({
    super.key,
    required this.title,
    this.page,
    this.isBottomSheet = false,
    this.type,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingcubitCubit(),
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                if (subtitle != null) // يظهر فقط لو فيه subtitle
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        color: Color(0xFFBCBDBD),
                      ),
                    ),
                  ),
                const Icon(Icons.arrow_forward_ios, size: 25),
              ],
            ),
            onTap: () {
              final settingCubit = BlocProvider.of<SettingcubitCubit>(context);

              if (isBottomSheet && type != null) {
                settingCubit.showBottomSheet(context, type!);
              } else if (page != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page!),
                );
              }
            },
          );
        },
      ),
    );
  }
}
