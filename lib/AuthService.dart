import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'Login.dart'; // Replace with your Login model if different
import 'SignUp Model.dart'; // Ensure this matches your SignUp model

class AuthService with ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> signUp(
      String firstName,
      String lastName,
      String countryCode,
      String phone,
      String email,
      String password,
      String confirmPassword,
      ) async {
    final url = Uri.parse('https://mmfinfotech.co/machine_test/api/userRegister');

    try {
      final response = await http.post(
        url,
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'countryCode': countryCode,
          'phone': phone,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          // Sign up successful, you may want to parse the data if needed
          print('Signup successful: ${data['message']}');
        } else {
          // Sign up failed, handle the error message
          throw Exception('Failed to signup: ${data['message']}');
        }
      } else {
        // Handle server errors
        throw Exception('Failed to signup: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to signup: $e');
    }
  }



}

