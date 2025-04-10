import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/core/utilities/dialog_utils.dart';
import 'package:greanspherproj/features/dashboard/controller/cubit/dashboardcubit_cubit.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/view/ComponentPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Notification/view/NotificationPage.dart';
import 'package:greanspherproj/features/dashboard/modelus/Profile/view/ProfilePage.dart';

class DahboardPage extends StatelessWidget {
  const DahboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardcubitCubit(),
      child: BlocBuilder<DashboardcubitCubit, DashboardcubitState>(
        builder: (context, state) {
          final DashboardcubitCubit controller =
              context.read<DashboardcubitCubit>();
          return Scaffold(
            body: PageView(
              controller: controller.pageController,
              onPageChanged: controller.OnChangeTabIndex,
              children: [
                HomePage(),
                ComponentPage(),
                NotificationsPage(),
                ProfileScreen(
                  userName: "Batoul",
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.selectedTapIndex,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              onTap: controller.OnChangeTabIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 35,
                      height: 50,
                      child: ImageIcon(AssetImage(
                        "assets/images/Frame 122.png",
                      )),
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SizedBox(
                        width: 76,
                        height: 50,
                        child: ImageIcon(
                            AssetImage("assets/images/Frame 114.png"))),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SizedBox(
                        width: 76,
                        height: 50,
                        child: ImageIcon(
                            AssetImage("assets/images/Frame 123.png"))),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 39,
                      height: 50,
                      child: ImageIcon(
                          AssetImage("assets/images/Frame 123 (1).png")),
                    ),
                    label: '')
              ],
            ),
          );
        },
      ),
    );
  }
}
