import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = "http://192.168.0.100:3000/api/auth";

  // ✅ Register User
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String country,
    required bool termsAccepted,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'country': country,
          'termsAccepted': termsAccepted,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error during registration: $e");
      return {'error': "Error during registration: $e"};
    }
  }

  // ✅ Login User (Fixed, with SharedPreferences)
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Store userId in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', responseData['userId']);

        return responseData;
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error during login: $e");
      return {'error': "Error during login: $e"};
    }
  }

  // ✅ Fetch User Emergency Status
  static Future<Map<String, dynamic>> fetchUserEmergencyStatus(String userId) async {
    final url = Uri.parse('$_baseUrl/getUser/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error fetching emergency status: $e");
      return {'error': "Error fetching emergency status: $e"};
    }
  }

  // ✅ Fetch User Profile
  static Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final url = Uri.parse('$_baseUrl/profile/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
      return {'error': "Error fetching profile: $e"};
    }
  }

  // ✅ Update User Profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String country,
  }) async {
    final url = Uri.parse('$_baseUrl/profile/update/$userId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'phone': phone,
          'country': country,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error updating profile: $e");
      return {'error': "Error updating profile: $e"};
    }
  }

  // ✅ Change User Password
  static Future<Map<String, dynamic>> changeUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/changePassword/$userId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': json.decode(response.body)['msg'] ?? 'Unknown error'};
      }
    } catch (e) {
      print("❌ Error changing password: $e");
      return {'error': "Error changing password: $e"};
    }
  }

}
