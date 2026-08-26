import 'package:flutter/material.dart';

import '../features/auth/auth_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final AuthService _authService =
      AuthService();

  bool _loading = false;
  String? _errorMessage;

  Future<void> _signInWithGoogle() async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result =
          await _authService.signInWithGoogle();

      if (!mounted) return;

      if (result == null) {
        setState(() {
          _errorMessage =
              'No se pudo completar el inicio de sesión.';
        });
      }
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 30,
            ),
            child: Column(
              children: [
                _buildLogo(),

                const SizedBox(height: 30),

                const Text(
                  'Phone Diagnostic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        AppTheme.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Revisa tu teléfono de forma '
                  'rápida, sencilla y segura.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color:
                        AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                _buildLoginCard(),

                const SizedBox(height: 25),

                const Text(
                  'Tus diagnósticos se realizan '
                  'directamente en tu dispositivo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color:
                        AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: AppTheme.primary
            .withValues(alpha: 0.10),
        borderRadius:
            BorderRadius.circular(42),
      ),
      child: Center(
        child: Container(
          width: 105,
          height: 105,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius:
                BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary
                    .withValues(alpha: 0.22),
                blurRadius: 25,
                offset:
                    const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.phone_android_rounded,
            color: Colors.white,
            size: 58,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Comienza ahora',
            style: TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
              color:
                  AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Inicia sesión para acceder '
            'a Phone Diagnostic.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color:
                  AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading
                  ? null
                  : _signInWithGoogle,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.g_mobiledata_rounded,
                      size: 30,
                    ),
              label: Text(
                _loading
                    ? 'Conectando...'
                    : 'Continuar con Google',
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.danger
                    .withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color:
                        AppTheme.danger,
                    size: 22,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color:
                            AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}