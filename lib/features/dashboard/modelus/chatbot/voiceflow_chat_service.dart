// lib/features/dashboard/modelus/chatbot/service/voiceflow_chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class VoiceflowChatService {
  static const String _projectID =
      '6855bdda210563ada9416c94'; // <--- Project ID
  static const String _apiKey =
      'VF.DM.685e6e0c6d11809d0f15f2dc.u0HCp2yi6WKyfE2P'; // <--- مهم جداً: ضع هنا الـ API Key بتاع Voiceflow
  static const String _baseUrl = 'https://general-runtime.voiceflow.com';
  static const String _userIdKey = 'voiceflow_user_id';

  Future<String> _getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);

    if (userId == null) {
      userId = const Uuid().v4();
      await prefs.setString(_userIdKey, userId);
    }
    return userId;
  }

  Future<List<String>> sendMessage(String message) async {
    final userId = await _getOrCreateUserId();
    // في ملف voiceflow_chat_service.dart
    final url = Uri.parse(
        '$_baseUrl/v2/interact'); // <--- هذا هو الـ URL الصحيح للـ API// <--- URL الجديد لـ v2/interact

    final response = await http.post(
      url,
      headers: {
        'Authorization': _apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        // <--- Body الجديد المتوقع من v2/interact
        'action': {
          'type': 'text',
          'payload': message,
        },
        'config': {
          'tts': false, // لو مش بتستخدم تحويل النص لكلام
          'stripSSML': true,
          'lastInteraction': true,
        },
        'versionID': 'production', // حسب الـ Version ID اللي عندك في Voiceflow
        'projectID': _projectID, // <--- Project ID لازم يتبعت هنا
        'sessionID': userId, // <--- الـ userId بتاعنا هو الـ sessionID
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> traces = jsonDecode(response.body);
      final List<String> responses = [];

      for (var trace in traces) {
        // قم بتحليل الـ traces بناءً على نوع الـ trace
        if (trace['type'] == 'text') {
          responses.add(trace['payload']['message']);
        }
        // لو فيه أنواع traces تانية زي 'speak' أو 'path' أو 'visual' ممكن تضيفها
        // if (trace['type'] == 'speak') { responses.add(trace['payload']['message']); }
      }
      return responses;
    } else {
      print(
          'Voiceflow API Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Voiceflow API error: ${response.statusCode}');
    }
  }
}
