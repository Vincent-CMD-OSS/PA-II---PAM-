import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/screens/login_screen.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/screens/dashboard_screen.dart';

// 🆕 Ubah jadi StatefulWidget
class KiaApp extends StatefulWidget {
  const KiaApp({super.key});

  @override
  State<KiaApp> createState() => _KiaAppState();
}

// 🆕 Tambahkan WidgetsBindingObserver untuk deteksi minimize/resume
class _KiaAppState extends State<KiaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Mulai mendengarkan siklus app
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Berhenti mendengarkan
    super.dispose();
  }

  // 🆕 Fungsi yang otomatis terpanggil saat app dibuka dari background/minimize
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSessionValidity();
    }
  }

  Future<void> _checkSessionValidity() async {
    // 1. Muat data session dari disk (termasuk waktu)
    await AuthSession.initialize();

    // 2. Kalau token ada, tapi statusnya SUDAH TIDAK VALID
    if (AuthSession.isLoggedIn && !AuthSession.isSessionValid) {
      if (mounted) {
        // Paksa logout lewat BLoC tanpa konfirmasi (karena ini aturan keamanan sistem)
        context.read<AuthBloc>().add(const AuthLogoutRequested());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi KIA Cerdas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // 🆕 WRAP SELURUH APP DENGAN LISTENER UNTUK MENDITEKSI AKTIVITAS
      builder: (context, child) {
        return Listener(
          onPointerDown: (_) {
            // Setiap kali jari menyentuh layar (klik, scroll, dsb)
            if (AuthSession.isLoggedIn) {
              AuthSession.updateActivity(); // Update stempel waktu
            }
          },
          child: child,
        );
      },
      // 🆕 GANTI HOME STATIS DENGAN BLOCBUILDER (REAKTIF TERHADAP LOGOUT PAKSA)
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Jika sudah login, atau sedang menunggu cek awal tapi token ada
          if (state is AuthAuthenticated || 
              (state is AuthInitial && AuthSession.isLoggedIn)) {
            return const DashboardScreen();
          }
          // Jika tidak login, atau dipaksa logout
          return const LoginScreen();
        },
      ),
    );
  }
}