import 'package:flutter/material.dart';

import '../features/battery/battery_diagnostic.dart';
import '../theme/app_theme.dart';
import '../widgets/diagnostic_card.dart';
import '../widgets/diagnostic_header.dart';
import '../widgets/diagnostic_status.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() =>
      _BatteryScreenState();
}

class _BatteryScreenState
    extends State<BatteryScreen> {
  final BatteryDiagnostic diagnostic =
      BatteryDiagnostic();

  bool testing = false;

  Future<void> _test() async {
    if (testing) return;

    setState(() {
      testing = true;
    });

    await diagnostic.test();

    if (!mounted) return;

    setState(() {
      testing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasResult =
        !testing && diagnostic.working;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batería'),
      ),
      body: SafeArea(
        child: ListView(
          physics:
              const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            DiagnosticHeader(
              icon: _batteryIcon(),
              title: 'Diagnóstico de batería',
              description:
                  'Consulta el nivel de carga y el estado '
                  'actual de la batería de tu teléfono.',
              color: AppTheme.success,
            ),

            const SizedBox(height: 25),

            if (testing)
              _buildLoadingCard(),

            if (hasResult)
              _buildBatteryCard(),

            const SizedBox(height: 18),

            DiagnosticStatus(
              success: diagnostic.working,
              title: diagnostic.working
                  ? 'Batería accesible'
                  : 'Estado de la prueba',
              message: diagnostic.message,
            ),

            const SizedBox(height: 25),

            _buildTestButton(),

            const SizedBox(height: 15),

            const Text(
              'La prueba consulta el nivel y el estado '
              'actual de la batería del dispositivo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _batteryIcon() {
    if (diagnostic.level >= 80) {
      return Icons.battery_full_rounded;
    }

    if (diagnostic.level >= 50) {
      return Icons.battery_5_bar_rounded;
    }

    if (diagnostic.level >= 20) {
      return Icons.battery_3_bar_rounded;
    }

    return Icons.battery_1_bar_rounded;
  }

  Widget _buildLoadingCard() {
    return const DiagnosticCard(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          SizedBox(height: 18),

          Text(
            'Consultando batería...',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Obteniendo la información actual '
            'del dispositivo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryCard() {
    final level =
        diagnostic.level.clamp(0, 100);

    final Color color = level <= 20
        ? AppTheme.danger
        : level <= 50
            ? AppTheme.accent
            : AppTheme.success;

    return DiagnosticCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: CircularProgressIndicator(
                  value: level / 100,
                  strokeWidth: 14,
                  backgroundColor:
                      const Color(0xFFF0F1F6),
                  color: color,
                  strokeCap: StrokeCap.round,
                ),
              ),

              Column(
                children: [
                  Text(
                    '$level%',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),

                  const Text(
                    'carga',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          _buildInfoRow(
            icon: Icons.battery_std_rounded,
            iconColor: color,
            title: 'Estado de batería',
            value: diagnostic.stateText,
            valueColor: color,
            backgroundColor:
                color.withValues(alpha: 0.08),
          ),

          const SizedBox(height: 10),

          _buildInfoRow(
            icon: diagnostic.powerSaveMode
                ? Icons.battery_saver_rounded
                : Icons.battery_std_rounded,
            iconColor: AppTheme.primary,
            title: 'Modo ahorro',
            value: diagnostic.powerSaveMode
                ? 'ACTIVADO'
                : 'DESACTIVADO',
            valueColor:
                diagnostic.powerSaveMode
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
            backgroundColor:
                AppTheme.background,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 25,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            testing ? null : _test,
        icon: Icon(
          testing
              ? Icons.hourglass_top_rounded
              : Icons.battery_full_rounded,
        ),
        label: Text(
          testing
              ? 'Consultando...'
              : 'Consultar batería',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}