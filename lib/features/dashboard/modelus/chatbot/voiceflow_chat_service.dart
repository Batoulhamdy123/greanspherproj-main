// lib/features/dashboard/modelus/chatbot/service/voiceflow_chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class VoiceflowChatService {
  static const String _projectID =
      '6855bdda210563ada9416c94'; // <--- Project ID
  static const String _apiKey =
      'VF.DM.685e6e0c6d11809d0f15f2dc.u0HCp2yi6WKyfE2P'; // <--- ضع هنا الـ API Key بتاع Voiceflow
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
    // هذا هو الـ URL الذي يعمل في Postman
    final url = Uri.parse(
        '$_baseUrl/state/user/$userId/interact'); // <--- URL مطابق لـ Postman

    final response = await http.post(
      url,
      headers: {
        // Headers في Postman كانت فقط Content-Type
        // لا يوجد Authorization Header في Postman لهذا الـ Endpoint
        'Content-Type': 'application/json',
        'Authorization': _apiKey,
      },
      body: jsonEncode({
        // <--- Body مطابق لـ Postman
        'type': 'text',
        'payload': message,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> traces = jsonDecode(response.body);
      final List<String> responses = [];

      for (var trace in traces) {
        if (trace['type'] == 'text') {
          responses.add(trace['payload']['message']);
        }
        // قم بتحليل أنواع الـ traces الأخرى لو الشات بوت بيرجعها
        // if (trace['type'] == 'speak') { responses.add(trace['payload']['message']); }
        // if (trace['type'] == 'path') { /* handle path */ }
        // if (trace['type'] == 'visual') { /* handle visual */ }
      }
      return responses;
    } else {
      print(
          'Voiceflow API Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Voiceflow API error: ${response.statusCode}');
    }
  }
}
