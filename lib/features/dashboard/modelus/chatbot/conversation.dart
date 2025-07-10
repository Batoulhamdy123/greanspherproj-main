// lib/features/dashboard/modelus/chatbot/conversation.dart
import 'package:flutter/material.dart';
import 'package:greanspherproj/features/dashboard/modelus/chatbot/voiceflow_chat_service.dart';
//import 'package:greanspherproj/features/dashboard/modelus/chatbot/service/voiceflow_chat_service.dart'; // <--- استيراد خدمة الشات بوت

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages =
      []; // قائمة الرسائل (sender: message)
  final VoiceflowChatService _chatService =
      VoiceflowChatService(); // كائن خدمة الشات بوت

  @override
  void initState() {
    super.initState();
    // رسالة ترحيبية أولية من البوت
    _messages.add({
      "sender": "bot",
      "message":
          "Hello! I'm Rooty, your hydroponic gardening assistant. How can I help you today?"
    });
  }

  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return; // لا ترسل رسالة فارغة

    // إضافة رسالة المستخدم إلى القائمة
    setState(() {
      _messages.add({"sender": "user", "message": userInput});
    });
    _controller.clear(); // مسح حقل الإدخال

    try {
      // إرسال الرسالة لـ Voiceflow API واستقبال الردود
      final responses = await _chatService.sendMessage(userInput);
      setState(() {
        // إضافة كل رد من البوت إلى القائمة
        _messages
            .addAll(responses.map((msg) => {"sender": "bot", "message": msg}));
      });
    } catch (e) {
      // عرض رسالة خطأ إذا فشل الاتصال
      setState(() {
        _messages.add({
          "sender": "bot",
          "message":
              "Error: Failed to connect to Rooty. Please try again later."
        });
        print("Chatbot API Error: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Rooty ', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context), // زر رجوع
          icon: const Icon(Icons.arrow_back, color: Colors.green),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/chatbot.png', // <--- تأكد من وجود هذه الصورة
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isUser ? Colors.green.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUser ? Colors.black87 : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                    ),
                    onSubmitted: (value) =>
                        _sendMessage(), // إرسال بالضغط على Enter
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  // زر الإرسال [cite: conversation.dart]
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
