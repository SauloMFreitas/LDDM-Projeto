import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final List<String> validTokens = [];

  static String generateToken() {
    final random = Random.secure();
    final tokenBytes = List<int>.generate(32, (i) => random.nextInt(256));
    final token = base64Url.encode(tokenBytes);
    validTokens.add(token);
    return token;
  }

  Future<String?> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      final userData = json.decode(userDataJson);
      final token = userData['token'];

      if (token != null) {
        return token;
      }
    }

    return null;
  }

  Future<bool> isValidToken() async {
    final token = await getTokenFromSharedPreferences();
    return validTokens.contains(token);
  }

  Future<void> invalidateToken() async {
    final token = await getTokenFromSharedPreferences();
    validTokens.remove(token);
  }
}
