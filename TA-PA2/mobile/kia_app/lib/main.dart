import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

import 'core/services/auth_session.dart';
import 'core/services/firebase_service.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseService.initialize();

  await AuthSession.initialize();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: const KiaApp(),
    ),
  );
}