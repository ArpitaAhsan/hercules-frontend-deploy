import 'package:flutter/material.dart';
import 'package:hercules/login_page.dart';
import 'package:hercules/styles/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,  // ✅ Background color applied here
      ),
      home: LoginPage(),
    );
  }
}
