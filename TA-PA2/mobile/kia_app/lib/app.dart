import 'package:flutter/material.dart';
import 'core/services/auth_session.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

class KiaApp extends StatelessWidget {
  const KiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi KIA Cerdas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AuthSession.isLoggedIn
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}