import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:ta_pa2_pa3_project/features/auth/presentation/bloc/auth_state.dart';

import 'package:ta_pa2_pa3_project/features/dashboard/presentation/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final _identifierController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {

    _identifierController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  // Submit Login
  void _submit() {

    try {

      if (!_formKey.currentState!
          .validate()) {
        return;
      }

      context.read<AuthBloc>().add(

            AuthLoginRequested(

              identifier:
                  _identifierController.text
                      .trim(),

              password:
                  _passwordController.text,
            ),
          );

    } catch (e) {

      debugPrint(
        'Login submit error: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthBloc, AuthState>(

      listener: (context, state) {

        if (state is AuthAuthenticated) {

          Navigator.of(context)
              .pushAndRemoveUntil(

            MaterialPageRoute(
              builder: (_) =>
                  const DashboardScreen(),
            ),

            (route) => false,
          );

        } else if (state is AuthError) {

          ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            behavior:
                SnackBarBehavior.floating,

            backgroundColor:
                AppColors.danger,

            elevation: 0,

            margin:
                const EdgeInsets.all(16),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),

            content: Text(

              state.message,

              style: const TextStyle(

                color: AppColors.white,

                fontWeight:
                    FontWeight.w500,

                fontSize: 14,
              ),
            ),

            duration:
                const Duration(seconds: 3),
          ),
        );
        }
      },

      child: Scaffold(

        backgroundColor:
            AppColors.background,

        body: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              colors: [
                AppColors.primary,
                Color(0xFF42A5F5),
              ],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: SafeArea(

            child: Center(

              child: SingleChildScrollView(

                padding:
                    const EdgeInsets.all(20),

                child: Container(

                  padding:
                      const EdgeInsets.all(24),

                  decoration: BoxDecoration(

                    color: AppColors.white,

                    borderRadius:
                        BorderRadius.circular(24),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black
                            .withValues(
                          alpha: 0.10,
                        ),

                        blurRadius: 24,

                        offset:
                            const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Form(

                    key: _formKey,

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,

                      children: [

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/images/logo_kia.png',
                            height: 135,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(

                          'Masuk Akun KIA-Cerdas',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(

                            fontSize: 24,

                            fontWeight:
                                FontWeight.w700,

                            color:
                                AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(

                          'Gunakan email/no.telp untuk mengakses layanan KIA-Cerdas.',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            color:
                                AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        TextFormField(

                          controller:
                              _identifierController,

                          keyboardType:
                              TextInputType.emailAddress,

                          decoration: InputDecoration(

                            labelText:
                                'Email / Nomor Telepon',

                            labelStyle:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                            ),

                            filled: true,

                            fillColor:
                                AppColors.surface,

                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color:
                                  AppColors.primary,
                            ),

                            border:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  BorderSide.none,
                            ),

                            enabledBorder:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors.border,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),

                          validator: (value) {

                            try {

                              if (value == null ||
                                  value.trim()
                                      .isEmpty) {

                                return
                                    'Email atau nomor telepon wajib diisi';
                              }

                              final input =
                                  value.trim();

                              if (input
                                  .contains('@')) {

                                final emailRegex =
                                    RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                );

                                if (!emailRegex
                                    .hasMatch(
                                  input,
                                )) {

                                  return
                                      'Format email tidak valid';
                                }
                              }

                              return null;

                            } catch (e) {

                              debugPrint(
                                'Identifier validation error: $e',
                              );

                              return
                                  'Terjadi kesalahan validasi';
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(

                          controller:
                              _passwordController,

                          obscureText:
                              _obscure,

                          decoration:
                              InputDecoration(

                            labelText:
                                'Password',

                            labelStyle:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                            ),

                            filled: true,

                            fillColor:
                                AppColors.surface,

                            prefixIcon:
                                const Icon(
                              Icons.lock_outline,
                              color:
                                  AppColors.primary,
                            ),

                            suffixIcon:
                                IconButton(

                              onPressed: () {

                                try {

                                  setState(() {
                                    _obscure =
                                        !_obscure;
                                  });

                                } catch (e) {

                                  debugPrint(
                                    'Toggle password error: $e',
                                  );
                                }
                              },

                              icon: Icon(

                                _obscure
                                    ? Icons
                                        .visibility_off
                                    : Icons
                                        .visibility,

                                color: AppColors
                                    .textSecondary,
                              ),
                            ),

                            border:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  BorderSide.none,
                            ),

                            enabledBorder:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors.border,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),

                          validator: (value) {

                            try {

                              if (value == null ||
                                  value.isEmpty) {

                                return
                                    'Password wajib diisi';
                              }

                              if (value.length < 6) {

                                return
                                    'Password minimal 6 karakter';
                              }

                              return null;

                            } catch (e) {

                              debugPrint(
                                'Password validation error: $e',
                              );

                              return
                                  'Terjadi kesalahan validasi';
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        BlocBuilder<AuthBloc,
                            AuthState>(

                          builder:
                              (context, state) {

                            final isLoading =
                                state
                                    is AuthLoading;

                            return SizedBox(

                              height: 52,

                              child: FilledButton(

                                style:
                                    FilledButton
                                        .styleFrom(

                                  backgroundColor:
                                      AppColors
                                          .primary,

                                  disabledBackgroundColor:
                                      AppColors
                                          .primary
                                          .withValues(
                                    alpha: 0.5,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(

                                    borderRadius:
                                        BorderRadius.circular(
                                      14,
                                    ),
                                  ),
                                ),

                                onPressed:
                                    isLoading
                                        ? null
                                        : _submit,

                                child:
                                    isLoading

                                        ? const SizedBox(

                                            width:
                                                22,

                                            height:
                                                22,

                                            child:
                                                CircularProgressIndicator(

                                              strokeWidth:
                                                  2,

                                              color:
                                                  AppColors.white,
                                            ),
                                          )

                                        : const Text(

                                            'Login',

                                            style:
                                                TextStyle(

                                              color:
                                                  AppColors.white,

                                              fontSize:
                                                  16,

                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}