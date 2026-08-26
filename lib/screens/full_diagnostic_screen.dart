import 'dart:async';

import 'package:flutter/material.dart';

import '../core/diagnostics/diagnostic_engine.dart';
import '../core/diagnostics/diagnostic_result.dart';
import '../core/diagnostics/diagnostic_status.dart';
import '../features/history/diagnostic_history_service.dart';

import 'audio_screen.dart';
import 'camera_screen.dart';
import 'microphone_screen.dart';
import 'pedometer_screen.dart';
import 'vibration_screen.dart';

class FullDiagnosticScreen extends StatefulWidget {
  const FullDiagnosticScreen({super.key});

  @override
  State<FullDiagnosticScreen> createState() =>
      _FullDiagnosticScreenState();
}

class _FullDiagnosticScreenState
    extends State<FullDiagnosticScreen> {
  final DiagnosticEngine engine =
      DiagnosticEngine();

  final DiagnosticHistoryService historyService =
      DiagnosticHistoryService();

  List<DiagnosticResult> results = [];

  bool running = false;
  bool interactiveRunning = false;
  bool completed = false;

  String currentTest = '';

  static const int totalExpectedTests = 13;

  // ============================================================
  // DIAGNÓSTICO COMPLETO
  // ============================================================

  Future<void> _startDiagnostic() async {
    if (running || interactiveRunning) {
      return;
    }

    setState(() {
      running = true;
      interactiveRunning = false;
      completed = false;
      currentTest =
          'Preparando diagnóstico...';
      results = [];
    });

    try {
      // ==========================================================
      // AUTOMÁTICAS
      // ==========================================================

      setState(() {
        currentTest =
            'Comprobando componentes automáticamente...';
      });

      final automaticResults =
          await engine.runAutomaticDiagnostics();

      if (!mounted) return;

      setState(() {
        results =
            List<DiagnosticResult>.from(
          automaticResults,
        );

        running = false;
        interactiveRunning = true;
        currentTest =
            'Preparando pruebas interactivas...';
      });

      // ==========================================================
      // INTERACTIVAS
      // ==========================================================

      await _runInteractiveDiagnostics();

      if (!mounted) return;

      setState(() {
        running = false;
        interactiveRunning = false;
        completed = true;
        currentTest =
            'Diagnóstico completado';
      });

      // ==========================================================
      // GUARDAR EN FIRESTORE
      // ==========================================================

      try {
        await historyService.saveDiagnostic(
          List<DiagnosticResult>.from(results),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Diagnóstico guardado en el historial.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El diagnóstico terminó, pero no se pudo guardar en el historial.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        running = false;
        interactiveRunning = false;
        completed = true;
        currentTest =
            'El diagnóstico terminó con errores';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error durante el diagnóstico: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // PRUEBAS INTERACTIVAS
  // ============================================================

  Future<void> _runInteractiveDiagnostics() async {
    await _cameraTest();

    if (!mounted) return;

    await _microphoneTest();

    if (!mounted) return;

    await _speakerTest();

    if (!mounted) return;

    await _vibrationTest();

    if (!mounted) return;

    await _pedometerTest();

    if (!mounted) return;

    await _notificationTest();
  }

  // ============================================================
  // CÁMARA
  // ============================================================

  Future<void> _cameraTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de cámara';
    });

    final result =
        await _openInteractiveScreen(
      const CameraScreen(),
      'Cámara',
    );

    if (!mounted) return;

    _addInteractiveResult(
      'Cámara',
      result,
    );
  }

  // ============================================================
  // MICRÓFONO
  // ============================================================

  Future<void> _microphoneTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de micrófono';
    });

    final result =
        await _openInteractiveScreen(
      const MicrophoneScreen(),
      'Micrófono',
    );

    if (!mounted) return;

    _addInteractiveResult(
      'Micrófono',
      result,
    );
  }

  // ============================================================
  // ALTAVOZ
  // ============================================================

  Future<void> _speakerTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de altavoz';
    });

    final result =
        await _openInteractiveScreen(
      const AudioScreen(),
      'Altavoz',
    );

    if (!mounted) return;

    _addInteractiveResult(
      'Altavoz',
      result,
    );
  }

  // ============================================================
  // VIBRACIÓN
  // ============================================================

  Future<void> _vibrationTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de vibración';
    });

    final result =
        await _openInteractiveScreen(
      const VibrationScreen(),
      'Vibración',
    );

    if (!mounted) return;

    _addInteractiveResult(
      'Vibración',
      result,
    );
  }

  // ============================================================
  // PODÓMETRO
  // ============================================================

  Future<void> _pedometerTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de podómetro';
    });

    final result =
        await _openInteractiveScreen(
      const PedometerScreen(),
      'Podómetro',
    );

    if (!mounted) return;

    _addInteractiveResult(
      'Podómetro',
      result,
    );
  }

  // ============================================================
  // NOTIFICACIONES
  // ============================================================

  Future<void> _notificationTest() async {
    if (!mounted) return;

    setState(() {
      currentTest =
          'Prueba de notificaciones';
    });

    final result =
        await engine.testNotifications();

    if (!mounted) return;

    results.add(result);

    setState(() {});
  }

  // ============================================================
  // ABRIR PRUEBA INTERACTIVA
  // ============================================================

  Future<bool?> _openInteractiveScreen(
    Widget screen,
    String component,
  ) async {
    if (!mounted) {
      return null;
    }

    try {
      final result =
          await Navigator.push<bool?>(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
        ),
      ).timeout(
        const Duration(seconds: 90),
        onTimeout: () {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  'La prueba de $component '
                  'tardó demasiado y fue omitida.',
                ),
              ),
            );
          }

          return null;
        },
      );

      return result;
    } on TimeoutException {
      return null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Error en la prueba de $component.',
            ),
          ),
        );
      }

      return false;
    }
  }

  // ============================================================
  // RESULTADO INTERACTIVO
  // ============================================================

  void _addInteractiveResult(
    String component,
    bool? result,
  ) {
    final DiagnosticStatus status;
    final String message;

    if (result == true) {
      status = DiagnosticStatus.ok;
      message =
          'Prueba completada correctamente';
    } else if (result == false) {
      status = DiagnosticStatus.failed;
      message =
          'La prueba no se completó correctamente';
    } else {
      status = DiagnosticStatus.notTested;
      message =
          'Prueba omitida o no completada';
    }

    results.add(
      DiagnosticResult(
        component: component,
        status: status,
        message: message,
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // RESULTADOS
  // ============================================================

  int get successfulTests {
    return results
        .where(
          (result) =>
              result.status ==
              DiagnosticStatus.ok,
        )
        .length;
  }

  int get warningTests {
    return results
        .where(
          (result) =>
              result.status ==
              DiagnosticStatus.warning,
        )
        .length;
  }

  int get failedTests {
    return results
        .where(
          (result) =>
              result.status ==
              DiagnosticStatus.failed,
        )
        .length;
  }

  int get unavailableTests {
    return results
        .where(
          (result) =>
              result.status ==
              DiagnosticStatus.unavailable,
        )
        .length;
  }

  int get notTestedTests {
    return results
        .where(
          (result) =>
              result.status ==
              DiagnosticStatus.notTested,
        )
        .length;
  }

  bool get allTestsSuccessful {
    return results.length ==
            totalExpectedTests &&
        failedTests == 0 &&
        notTestedTests == 0;
  }

  double get progress {
    if (completed) {
      return 1.0;
    }

    if (results.isEmpty) {
      return 0.0;
    }

    final value =
        results.length /
        totalExpectedTests;

    return value.clamp(0.0, 1.0);
  }

  // ============================================================
  // ICONOS
  // ============================================================

  IconData _statusIcon(
    DiagnosticStatus status,
  ) {
    switch (status) {
      case DiagnosticStatus.ok:
        return Icons.check_circle_rounded;

      case DiagnosticStatus.warning:
        return Icons.warning_rounded;

      case DiagnosticStatus.failed:
        return Icons.cancel_rounded;

      case DiagnosticStatus.unavailable:
        return Icons.remove_circle_rounded;

      case DiagnosticStatus.notTested:
        return Icons.help_rounded;
    }
  }

  // ============================================================
  // COLOR ESTADO
  // ============================================================

  Color _statusColor(
    DiagnosticStatus status,
  ) {
    switch (status) {
      case DiagnosticStatus.ok:
        return Colors.green;

      case DiagnosticStatus.warning:
        return Colors.orange;

      case DiagnosticStatus.failed:
        return Colors.red;

      case DiagnosticStatus.unavailable:
        return Colors.grey;

      case DiagnosticStatus.notTested:
        return Colors.blueGrey;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    engine.dispose();

    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnóstico completo',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.all(20),
          children: [
            _buildHeader(),

            const SizedBox(height: 20),

            if (running ||
                interactiveRunning)
              _buildProgressCard(),

            if (completed)
              _buildFinalStatus(),

            const SizedBox(height: 18),

            if (results.isNotEmpty)
              _buildResultsSummary(),

            const SizedBox(height: 18),

            if (running ||
                interactiveRunning)
              _buildCurrentTest(),

            const SizedBox(height: 18),

            if (results.isNotEmpty)
              _buildResultsList(),

            if (!running &&
                !interactiveRunning &&
                !completed)
              _buildStartCard(),

            if (completed)
              _buildRestartButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(28),
            color:
                Theme.of(context)
                    .colorScheme
                    .primaryContainer,
          ),
          child: Icon(
            Icons
                .health_and_safety_rounded,
            size: 52,
            color:
                Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Chequeo del dispositivo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          completed
              ? 'Aquí tienes el resultado '
                  'de tu diagnóstico.'
              : 'Vamos a comprobar que '
                  'todo funcione correctamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROGRESO
  // ============================================================

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(24),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Diagnóstico en progreso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              Text(
                '${results.length}/'
                '$totalExpectedTests',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child:
                LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '${(progress * 100).round()}%'
            ' completado',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRUEBA ACTUAL
  // ============================================================

  Widget _buildCurrentTest() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child:
                CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prueba actual',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  currentTest,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESUMEN
  // ============================================================

  Widget _buildResultsSummary() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            Icons.check_circle_rounded,
            successfulTests,
            'Correctas',
            Colors.green,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _summaryCard(
            Icons.warning_rounded,
            warningTests,
            'Avisos',
            Colors.orange,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _summaryCard(
            Icons.cancel_rounded,
            failedTests,
            'Fallos',
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    IconData icon,
    int value,
    String label,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),
        color:
            color.withValues(alpha: 0.10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 5),

          Text(
            '$value',
            style: const TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LISTA DE RESULTADOS
  // ============================================================

  Widget _buildResultsList() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultados',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        ...results.map(
          (result) =>
              _buildResultCard(result),
        ),
      ],
    );
  }

  Widget _buildResultCard(
    DiagnosticResult result,
  ) {
    final color =
        _statusColor(result.status);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color:
            color.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  color.withValues(
                alpha: 0.14,
              ),
            ),
            child: Icon(
              _statusIcon(
                result.status,
              ),
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  result.component,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  result.message,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ESTADO FINAL
  // ============================================================

  Widget _buildFinalStatus() {
    final success =
        allTestsSuccessful;

    final color =
        success
            ? Colors.green
            : Colors.orange;

    return Container(
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
        color:
            color.withValues(alpha: 0.10),
      ),
      child: Column(
        children: [
          Icon(
            success
                ? Icons.verified_rounded
                : Icons
                    .warning_amber_rounded,
            size: 70,
            color: color,
          ),

          const SizedBox(height: 14),

          Text(
            success
                ? '¡Todo está funcionando!'
                : 'Diagnóstico completado',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$successfulTests de '
            '$totalExpectedTests pruebas correctas',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),

          if (failedTests > 0) ...[
            const SizedBox(height: 5),

            Text(
              '$failedTests prueba(s) '
              'requieren atención',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],

          if (unavailableTests > 0) ...[
            const SizedBox(height: 5),

            Text(
              '$unavailableTests componente(s) '
              'no disponibles',
              textAlign: TextAlign.center,
            ),
          ],

          if (notTestedTests > 0) ...[
            const SizedBox(height: 5),

            Text(
              '$notTestedTests prueba(s) '
              'no realizadas',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // INICIO
  // ============================================================

  Widget _buildStartCard() {
    return Container(
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.smartphone_rounded,
            size: 55,
          ),

          const SizedBox(height: 15),

          const Text(
            '¿Listo para revisar tu teléfono?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Primero comprobaremos los '
            'componentes automáticamente '
            'y después realizaremos las '
            'pruebas que necesitan tu participación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _startDiagnostic,
              icon: const Icon(
                Icons.play_arrow_rounded,
              ),
              label: const Padding(
                padding:
                    EdgeInsets.symmetric(
                  vertical: 14,
                ),
                child: Text(
                  'Iniciar diagnóstico',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPETIR
  // ============================================================

  Widget _buildRestartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _startDiagnostic,
        icon: const Icon(
          Icons.refresh_rounded,
        ),
        label: const Padding(
          padding:
              EdgeInsets.symmetric(
            vertical: 14,
          ),
          child: Text(
            'Repetir diagnóstico',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}