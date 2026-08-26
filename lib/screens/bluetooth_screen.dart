import 'package:flutter/material.dart';

import '../features/bluetooth/bluetooth_diagnostic.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() =>
      _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothDiagnostic diagnostic =
      BluetoothDiagnostic();

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
  void dispose() {
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.bluetooth,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico Bluetooth',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 20),

            if (diagnostic.devices.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: diagnostic.devices.length,
                  itemBuilder: (_, index) {
                    final device =
                        diagnostic.devices[index];

                    return ListTile(
                      leading:
                          const Icon(Icons.bluetooth),
                      title: Text(
                        device.device.platformName
                                .isNotEmpty
                            ? device.device.platformName
                            : 'Dispositivo desconocido',
                      ),
                      subtitle: Text(
                        device.device.remoteId.toString(),
                      ),
                    );
                  },
                ),
              ),

            const Spacer(),

            if (testing)
              const CircularProgressIndicator(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(Icons.bluetooth_searching),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Buscar dispositivos',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}