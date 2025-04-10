import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/AccountInfo/controller/cubit/account_info_cubit.dart';
//import '../cubit/account_info_cubit.dart';
import '../CustomWidget/account_info_text_fields.dart';
import 'package:greanspherproj/features/dashboard/modelus/Setttingpagess/DeleteAccount/DeleteAccount.dart';

class AccountInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountInfoCubit(),
      child: BlocBuilder<AccountInfoCubit, AccountInfoState>(
        builder: (context, state) {
          final cubit = context.read<AccountInfoCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Account info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              backgroundColor: Colors.white,
              leading: GestureDetector(
                child: Image.asset("assets/images/arrowback.png"),
                onTap: () => Navigator.pop(context),
              ),
              actions: [
                TextButton(
                  onPressed: cubit.toggleEditMode,
                  child: Text(
                    cubit.isEditing ? "Save" : "Edit",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountInfoTextFields(),
                  SizedBox(height: 20),
                  Text("Gender (optional)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text("Male",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          value: "Male",
                          groupValue: cubit.gender,
                          onChanged: cubit.isEditing
                              ? (value) => cubit.setGender(value!)
                              : null,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text("Female",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          value: "Female",
                          groupValue: cubit.gender,
                          onChanged: cubit.isEditing
                              ? (value) => cubit.setGender(value!)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: OutlinedButton(
                      onPressed: cubit.isEditing
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteAccountScreen()),
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 105),
                      ),
                      child: Text(
                        "Delete account",
                        style: TextStyle(
                            color: cubit.isEditing ? Colors.grey : Colors.green,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
