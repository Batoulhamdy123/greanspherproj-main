import 'package:flutter/material.dart';
import '../resource/color_manager.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ColorManager.white,
            content: Row(
              children: [
                CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: ColorManager.primary),
                  ),
                )
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
      {required BuildContext context,
      required String message,
      String title = '',
      String? posActionName,
      Function? posAction,
      String? negActionName,
      Function? negAction}) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(
            posActionName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: ColorManager.primary),
          )));
    }
    if (negActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(
            negActionName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: ColorManager.primary),
          )));
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ColorManager.white,
            content: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: ColorManager.primary)),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: ColorManager.primary),
            ),
            actions: actions,
          );
        });
  }
}