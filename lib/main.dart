import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AuthService.dart';
import 'HomeScreen.dart';
import 'Login.dart';
import 'Signup.dart';
import 'UserService.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp(
        title: 'Mobile Developer Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.token == null ? LoginScreen() : HomeScreen();
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}






