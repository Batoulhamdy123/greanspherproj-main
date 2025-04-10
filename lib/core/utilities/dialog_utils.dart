import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = "OK",
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = "Yes",
    String cancelButtonText = "No",
  }) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(cancelButtonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    required Widget content,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: content,
        );
      },
    );
  }

  static void showLoading({
    required BuildContext context,
    String message = "Loading...",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dialog Util Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                DialogUtils.showAlertDialog(
                  context: context,
                  title: "Alert Dialog",
                  message: "This is an alert dialog.",
                );
              },
              child: Text("Show Alert Dialog"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool isConfirmed = await DialogUtils.showConfirmationDialog(
                  context: context,
                  title: "Confirmation Dialog",
                  message: "Do you want to proceed?",
                );

                if (isConfirmed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You confirmed!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You canceled!")),
                  );
                }
              },
              child: Text("Show Confirmation Dialog"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                DialogUtils.showCustomDialog(
                  context: context,
                  content: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Custom Dialog", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 16),
                        Text("This is a custom dialog content."),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text("Show Custom Dialog"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                DialogUtils.showLoading(context: context);

                Future.delayed(Duration(seconds: 3), () {
                  DialogUtils.hideLoading(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Loading Completed")),
                  );
                });
              },
              child: Text("Show Loading"),
            ),
          ],
        ),
      ),
    );
  }
}
