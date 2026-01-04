import 'dart:convert';
import 'package:http/http.dart' as http;

const String BASE_URL = 'http://10.0.2.2:3000'; // Android emulator -> host machine
// en iOS simulador usar http://localhost:3000

class Api {
  static Future<Map<String, dynamic>> register(String name, String email, String phone) async {
    final res = await http.post(Uri.parse('$BASE_URL/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'phone': phone})
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> login(String email) async {
    final res = await http.post(Uri.parse('$BASE_URL/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email})
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getRewards() async {
    final res = await http.get(Uri.parse('$BASE_URL/api/rewards'));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> redeem(String rewardId, String userId) async {
    final res = await http.post(Uri.parse('$BASE_URL/api/rewards/$rewardId/redeem'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId})
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> validateRedemption(String scannedPayload, String signature, String staffApiKey) async {
    final res = await http.post(Uri.parse('$BASE_URL/api/redemptions/validate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'scanned_payload': scannedPayload,
        'signature': signature,
        'staff_api_key': staffApiKey
      })
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> registerPurchase(String ticketCode, double amount, String userId, String registeredBy) async {
    final res = await http.post(Uri.parse('$BASE_URL/api/purchases'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ticket_code': ticketCode,
        'amount': amount,
        'user_id': userId,
        'registered_by': registeredBy
      })
    );
    return jsonDecode(res.body);
  }
}