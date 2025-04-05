import 'package:flutter/material.dart';
import 'package:hercules/login_page.dart';
import 'package:hercules/home_page.dart';
import 'package:hercules/styles/app_colors.dart';
import 'package:hercules/location_page.dart';
import 'package:hercules/edit_profile.dart';
import 'package:hercules/profile_page.dart';
import 'package:hercules/config/app_routes.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'profile_provider.dart'; // Import your ProfileProvider class (make sure it's correct)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()), // Provide ProfileProvider
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          brightness: Brightness.light,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.pages,  // Use AppRoutes for route management
      ),
    );
  }
}
