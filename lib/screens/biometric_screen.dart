import 'package:flutter/material.dart';

import '../features/biometrics/biometric_diagnostic.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final BiometricDiagnostic diagnostic =
      BiometricDiagnostic();

  bool testing = false;

  Future<void> _test() async {
    setState(() {
      testing = true;
    });

    await diagnostic.test();

    if (mounted) {
      setState(() {
        testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.fingerprint,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico biométrico',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),

            const Spacer(),

            if (testing)
              const CircularProgressIndicator(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(Icons.fingerprint),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Probar biometría',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (diagnostic.authenticated)
              const Text(
                '✓ BIOMETRÍA FUNCIONANDO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}