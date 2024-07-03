import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  List<User> _users = [];
  int _currentPage = 1;
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _isLoading = false;
      notifyListeners();
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('https://mmfinfotech.co/machine_test/api/userList?page=$_currentPage'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('userList')) {
          final userList = data['userList'] as List;
          if (loadMore) {
            _users.addAll(userList.map((json) => User.fromJson(json)).toList());
          } else {
            _users = userList.map((json) => User.fromJson(json)).toList();
          }
          _currentPage++;
        } else {
          throw Exception('Unexpected data format: $data');
        }
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      throw e; // Rethrow the error to handle it in UI or catch block
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _users.clear();
    notifyListeners();
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
    );
  }
}
