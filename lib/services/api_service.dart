// services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class ApiService {
  // Register a new user
  Future<Map<String, dynamic>> registerUser(String phoneNumber) async {
    try {
      print("Sending Request");
      final response = await http.post(
        Uri.parse(ApiConstants.registerUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
        }),
      );
      print(response.body);
      print("Request Sent");
      // Instead of streaming, directly decode the response
      if (response.statusCode == 201) {
        print("Request Successful");
        print(response.body);
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Request Failed");
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Network error: $e');
    }
  }

// Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      print("Sending Request");
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtpEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
      );
      print("Request Sent");

      if (response.statusCode == 200) {
        print("Request Successful");
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Request Failed");
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

// Register Pin
  Future<Map<String, dynamic>> registerPin(
      String phoneNumber, String pin) async {
    try {
      print("Sending Request");
      final response = await http.post(
        Uri.parse(ApiConstants.registerPin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': phoneNumber, 'pin': pin}),
      );
      print("Request Sent");

      if (response.statusCode == 200) {
        print("Request Successful");
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Request Failed");
        throw Exception('Invalid PIN');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> agreeToTerms(String phoneNumber) async {
    try {
      print("Sending Request");
      final response = await http.post(
        Uri.parse(ApiConstants.agreeToTerms),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );
      print("Request Sent");

      if (response.statusCode == 200) {
        print("Request Successful");
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Request Failed");
        throw Exception('Error occured while trying to proccess response');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

// Register user info (first name and last name)
  Future<Map<String, dynamic>> registerUserInfo(
      String phoneNumber, String firstName, String lastName) async {
    try {
      print("Sending Request");
      final response = await http.post(
        Uri.parse(ApiConstants.registerUserInfoEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'firstName': firstName,
          'lastName': lastName
        }),
      );
      print("Request Sent");

      if (response.statusCode == 200) {
        print("Successfully Registered");
        return json.decode(response.body);
      } else {
        print("Failed to update user info");
        throw Exception('Failed to update user info');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
