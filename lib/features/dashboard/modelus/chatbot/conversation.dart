import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/Home/view/home_screen.dart';
import 'package:greanspherproj/features/dashboard/view/dashboardpage.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Hello Boba 👋", isUser: false),
    ChatMessage(
      text:
          "I’m Rooty, your hydroponic gardening assistant!\nI’m here to help you grow healthy plants without soil.\nAsk me anything about plant care, hydroponic systems, or even where to buy the best supplies.\nLet’s grow something amazing together!",
      isUser: false,
    ),
    ChatMessage(
        text: "What’s the best plant to start with in hydroponics?",
        isUser: true),
    ChatMessage(
        text: "How much light do hydroponic plants need?", isUser: true),
  ];

  final TextEditingController _controller = TextEditingController();

  void _handleSend(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      // هنا ممكن بعدين تبعتي النص للـ AI وتستني الرد
    });
    _controller.clear();
  }

  void _showEndSessionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'End session',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to end this chat?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              /*  Expanded(
                  flex: 1,
                  child: Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                    thickness: 1.0,
                  )),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      /* Navigator.pop(context); // يقفل البوتوم شيت
                      Navigator.pushReplacementNamed(context, '/home');
                      // أو لو بتستخدمي Navigator.push:
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));*/
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: Color(0xFFF3F3F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DahboardPage()),
                      );
                      /* Navigator.pop(context); // يقفل البوتوم شيت
                      Navigator.pushReplacementNamed(context, '/home');
                      // أو لو بتستخدمي Navigator.push:
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));*/
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: Color(0xFFF3F3F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Yes, end',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Rooty',
              style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
              onPressed: _showEndSessionSheet,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.green,
              ))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Container(
              child: Image.asset(
                "assets/images/conversationchatbot.png",
                width: 100,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.green[400] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          /*  const Divider(
            height: 1,
            indent: 10,
            endIndent: 10,
          ),*/
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message to Rooty',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _handleSend(
                            _controller.text); // دي الدالة اللي تبعت الرسالة
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4CAF50), // أخضر زي الصورة
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )

              /*Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _handleSend,
                    decoration: const InputDecoration(
                      hintText: 'Type a message to Rooty',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.green,
                  ),
                  onPressed: () => _handleSend(_controller.text),
                ),
              ],
            ),*/
              ),
        ],
      ),
    );
  }
}
