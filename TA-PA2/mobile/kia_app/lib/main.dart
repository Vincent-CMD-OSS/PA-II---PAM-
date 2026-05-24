import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/auth_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSession.initialize();
  runApp(const KiaApp());
}