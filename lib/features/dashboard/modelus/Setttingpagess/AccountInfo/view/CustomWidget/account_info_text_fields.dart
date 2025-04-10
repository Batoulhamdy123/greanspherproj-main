import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/core/utilities/validation.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/controller/cubit/account_info_cubit.dart';

class AccountInfoTextFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AccountInfoCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: cubit.emailController,
          validator: MyValidation.validateEmail,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.black),
            labelText: "Email",
          ),
          enabled: cubit.isEditing,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: cubit.firstNameController,
          validator: MyValidation.validateName,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle, color: Colors.black),
            labelText: "First Name",
          ),
          enabled: cubit.isEditing,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: cubit.lastNameController,
          validator: MyValidation.validateName,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle, color: Colors.black),
            labelText: "Last Name",
          ),
          enabled: cubit.isEditing,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: cubit.dateController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: () => cubit.selectDate(context),
            ),
            labelText: "Date of birth (optional)",
          ),
          onTap: () => cubit.selectDate(context),
        ),
      ],
    );
  }
}
