import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'dashboardcubit_state.dart';

class DashboardcubitCubit extends Cubit<DashboardcubitState> {
  DashboardcubitCubit() : super(DashboardcubitInitial());
  int selectedTapIndex = 0;
  final PageController pageController = PageController();
  void OnChangeTabIndex(int index) {
    selectedTapIndex = index;
    pageController.jumpToPage(selectedTapIndex);
    emit(DashboardcubitInitial());
  }
}
