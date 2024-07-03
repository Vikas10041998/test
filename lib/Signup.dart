import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthService.dart';
import 'Login.dart'; // Replace with your Login model if different
import 'SignUp Model.dart'; // Ensure this matches your SignUp model
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _countryCodeController,
                  decoration: InputDecoration(labelText: 'Country Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        // Prepare data to send
                        var data = {
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'country_code': _countryCodeController.text,
                          'phone': _phoneController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'confirm_password': _confirmPasswordController.text,
                        };

                        // Encode the data
                        var body = json.encode(data);

                        // Make HTTP POST request
                        var response = await http.post(
                          Uri.parse('https://mmfinfotech.co/machine_test/api/userRegister'),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: body,
                        );

                        // Check status code for success or failure
                        if (response.statusCode == 200) {
                          // Successful signup
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _countryCodeController.clear();
                          _phoneController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign Up Successful')),
                          );

                          // Navigate to login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        } else {
                          // Failed to signup
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to Sign Up')),
                          );
                          print('Failed to sign up: ${response.statusCode}');
                        }
                      } catch (e) {
                        // Handle other exceptions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to Sign Up')),
                        );
                        print('Failed to sign up: $e');
                      }
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
