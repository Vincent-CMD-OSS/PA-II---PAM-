import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/auth_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSession.initialize();
  // runApp(const KiaApp());
  runApp(
    BlocProvider<AuthBloc> (
      create: (context) => AuthBloc(),
      child: const KiaApp(),
    )
  );
}