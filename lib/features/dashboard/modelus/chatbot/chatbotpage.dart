import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/chatbot/conversation.dart'; // <--- استيراد ChatScreen

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          /*leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50), // أضف const
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/chatscreen1.png", // <--- تأكد من وجود هذه الصورة
                    width: 293,
                    height: 300,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    // أضف const
                    "welcome ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.black),
                  ),
                  const Text(
                    // أضف const
                    "Let’s start a conversation with Rooty",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    // أضف const
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChatScreen()), // <--- التأكد من استدعاء ChatScreen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 53, 135, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
