import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

import 'core/services/auth_session.dart';
import 'core/services/firebase_service.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'firebase_options.dart';

/// BACKGROUND NOTIFICATION HANDLER
// ⬇️ TAMBAHKAN BARIS INI! Ini wajib agar background notifikasi jalan saat HP terkunci
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print(
    "Background Message: ${message.messageId}",
  );
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Register background handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  /// Initialize Firebase Service
  await FirebaseService.initialize();

  /// Initialize Auth Session
  await AuthSession.initialize();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: const KiaApp(),
    ),
  );
}