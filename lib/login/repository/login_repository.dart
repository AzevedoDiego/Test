import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otp/otp.dart';

class LoginRepository {
  final String baseUrl = 'http://10.0.2.2:5000';
  String? _totpSecret;

  String generateTOTP(String secret) {
    return OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
  }

  Future<String?> getRecoverySecret({
    required String username,
    required String password,
    required String code,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/recovery-secret');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _totpSecret = data['totp_secret'];

        return _totpSecret;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    String? totpSecret,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'totp_code': generateTOTP(totpSecret!),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
