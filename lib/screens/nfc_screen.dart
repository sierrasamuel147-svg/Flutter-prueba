import 'package:flutter/material.dart';

import '../features/nfc/nfc_diagnostic.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  final NfcDiagnostic diagnostic = NfcDiagnostic();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _checkNfc();
  }

  Future<void> _checkNfc() async {
    await diagnostic.checkAvailability();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _startScan() async {
    setState(() {});

    await diagnostic.startScan();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopScan() async {
    await diagnostic.stopScan();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.nfc,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico NFC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 30),

            if (loading)
              const CircularProgressIndicator(),

            if (!loading && diagnostic.available)
              const Text(
                '✓ NFC disponible en el dispositivo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (!loading && !diagnostic.available)
              const Text(
                '✗ NFC no disponible',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            const Spacer(),

            if (diagnostic.scanning)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _stopScan,
                  icon: const Icon(Icons.stop),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Cancelar prueba',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            if (!diagnostic.scanning &&
                diagnostic.available)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.nfc),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Probar NFC',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            if (diagnostic.tagDetected)
              const Text(
                '✓ NFC FUNCIONANDO',
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