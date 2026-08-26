import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiagnosticHistoryDetailScreen
    extends StatelessWidget {
  const DiagnosticHistoryDetailScreen({
    super.key,
    required this.document,
  });

  final QueryDocumentSnapshot<
      Map<String, dynamic>> document;

  @override
  Widget build(BuildContext context) {
    final data = document.data();

    final int totalTests =
        _getInt(data['totalTests']);

    final int successfulTests =
        _getInt(data['successfulTests']);

    final int warningTests =
        _getInt(data['warningTests']);

    final int failedTests =
        _getInt(data['failedTests']);

    final int unavailableTests =
        _getInt(data['unavailableTests']);

    final int notTestedTests =
        _getInt(data['notTestedTests']);

    final Timestamp? timestamp =
        data['createdAt'] as Timestamp?;

    final DateTime? date =
        timestamp?.toDate();

    final List<dynamic> results =
        data['results'] is List
            ? data['results'] as List<dynamic>
            : [];

    final bool hasFailures =
        failedTests > 0;

    final bool hasWarnings =
        warningTests > 0;

    final Color statusColor =
        hasFailures
            ? Colors.red
            : hasWarnings
                ? Colors.orange
                : Colors.green;

    final IconData statusIcon =
        hasFailures
            ? Icons.cancel_rounded
            : hasWarnings
                ? Icons.warning_rounded
                : Icons.check_circle_rounded;

    final String statusText =
        hasFailures
            ? 'Requiere atención'
            : hasWarnings
                ? 'Completado con avisos'
                : 'Todo correcto';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle del diagnóstico',
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics:
            const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        children: [
          // =====================================================
          // RESUMEN PRINCIPAL
          // =====================================================

          _buildMainSummary(
            context,
            statusColor,
            statusIcon,
            statusText,
            date,
            totalTests,
            successfulTests,
          ),

          const SizedBox(height: 18),

          // =====================================================
          // ESTADÍSTICAS
          // =====================================================

          _buildStatistics(
            context,
            successfulTests,
            warningTests,
            failedTests,
            unavailableTests,
            notTestedTests,
          ),

          const SizedBox(height: 26),

          // =====================================================
          // RESULTADOS
          // =====================================================

          const Text(
            'Resultados de las pruebas',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          if (results.isEmpty)
            _buildNoResults(context)
          else
            ...results.map(
              (result) {
                if (result is Map) {
                  return _buildResultCard(
                    context,
                    Map<String, dynamic>.from(
                      result,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  // ============================================================
  // RESUMEN PRINCIPAL
  // ============================================================

  Widget _buildMainSummary(
    BuildContext context,
    Color statusColor,
    IconData statusIcon,
    String statusText,
    DateTime? date,
    int totalTests,
    int successfulTests,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
        color:
            statusColor.withValues(
          alpha: 0.09,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  statusColor.withValues(
                alpha: 0.14,
              ),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 44,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: statusColor,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _formatDate(date),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Text(
              '$successfulTests de '
              '$totalTests pruebas correctas',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  Widget _buildStatistics(
    BuildContext context,
    int successfulTests,
    int warningTests,
    int failedTests,
    int unavailableTests,
    int notTestedTests,
  ) {
    final List<Widget> cards = [
      _buildStat(
        icon:
            Icons.check_circle_outline_rounded,
        value: successfulTests,
        label: 'Correctas',
        color: Colors.green,
      ),
      _buildStat(
        icon:
            Icons.warning_amber_rounded,
        value: warningTests,
        label: 'Avisos',
        color: Colors.orange,
      ),
      _buildStat(
        icon:
            Icons.cancel_outlined,
        value: failedTests,
        label: 'Fallos',
        color: Colors.red,
      ),
    ];

    if (unavailableTests > 0) {
      cards.add(
        _buildStat(
          icon:
              Icons.remove_circle_outline,
          value: unavailableTests,
          label: 'No disp.',
          color: Colors.grey,
        ),
      );
    }

    if (notTestedTests > 0) {
      cards.add(
        _buildStat(
          icon:
              Icons.help_outline_rounded,
          value: notTestedTests,
          label: 'No probadas',
          color: Colors.blueGrey,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cards
          .map(
            (card) => SizedBox(
              width:
                  (MediaQuery.of(context)
                              .size
                              .width -
                          48) /
                      (cards.length <= 3
                          ? 3
                          : 3),
              child: card,
            ),
          )
          .toList(),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: 0.08),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 21,
            color: color,
          ),

          const SizedBox(height: 5),

          Text(
            '$value',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8A8EA3),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESULTADO INDIVIDUAL
  // ============================================================

  Widget _buildResultCard(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    final String component =
        result['component']?.toString() ??
            'Componente';

    final String status =
        result['status']?.toString() ??
            'notTested';

    final String message =
        result['message']?.toString() ??
            'Sin información';

    final dynamic details =
        result['details'];

    final Color color =
        _statusColor(status);

    final IconData icon =
        _statusIcon(status);

    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: 0.06),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              color.withValues(alpha: 0.14),
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color:
                        color.withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        component,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        _statusText(status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.65,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ),

            if (_hasDetails(details)) ...[
              const SizedBox(height: 12),

              _buildDetails(
                context,
                details,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DETALLES
  // ============================================================

  Widget _buildDetails(
    BuildContext context,
    dynamic details,
  ) {
    if (details is Map) {
      final entries =
          details.entries.toList();

      if (entries.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 9),

            ...entries.map(
              (entry) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          _formatDetailKey(
                            entry.key
                                .toString(),
                          ),
                          style:
                              const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        flex: 3,
                        child: Text(
                          _formatDetailValue(
                            entry.value,
                          ),
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                Color(
                              0xFF777C92,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    if (details is List) {
      return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Text(
          details
              .map(
                (item) =>
                    item.toString(),
              )
              .join(', '),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF777C92),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ============================================================
  // SIN RESULTADOS
  // ============================================================

  Widget _buildNoResults(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 40,
          ),

          SizedBox(height: 10),

          Text(
            'No hay detalles disponibles '
            'para este diagnóstico.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ESTADO
  // ============================================================

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case 'ok':
        return Colors.green;

      case 'warning':
        return Colors.orange;

      case 'failed':
        return Colors.red;

      case 'unavailable':
        return Colors.grey;

      case 'notTested':
        return Colors.blueGrey;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(
    String status,
  ) {
    switch (status) {
      case 'ok':
        return Icons.check_circle_rounded;

      case 'warning':
        return Icons.warning_rounded;

      case 'failed':
        return Icons.cancel_rounded;

      case 'unavailable':
        return Icons.remove_circle_rounded;

      case 'notTested':
        return Icons.help_rounded;

      default:
        return Icons.help_outline_rounded;
    }
  }

  String _statusText(
    String status,
  ) {
    switch (status) {
      case 'ok':
        return 'Funcionando correctamente';

      case 'warning':
        return 'Requiere atención';

      case 'failed':
        return 'Prueba fallida';

      case 'unavailable':
        return 'No disponible';

      case 'notTested':
        return 'No realizada';

      default:
        return 'Estado desconocido';
    }
  }

  // ============================================================
  // UTILIDADES
  // ============================================================

  int _getInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  bool _hasDetails(dynamic details) {
    if (details == null) {
      return false;
    }

    if (details is Map) {
      return details.isNotEmpty;
    }

    if (details is List) {
      return details.isNotEmpty;
    }

    return details.toString().isNotEmpty;
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Fecha no disponible';
    }

    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    final year =
        date.year.toString();

    final hour =
        date.hour.toString().padLeft(2, '0');

    final minute =
        date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year · '
        '$hour:$minute';
  }

  String _formatDetailKey(String key) {
    if (key.isEmpty) {
      return '';
    }

    final formatted =
        key.replaceAll(
      RegExp(r'([a-z])([A-Z])'),
      r'$1 $2',
    );

    return formatted[0].toUpperCase() +
        formatted.substring(1);
  }

  String _formatDetailValue(
    dynamic value,
  ) {
    if (value == null) {
      return '—';
    }

    if (value is double) {
      return value.toStringAsFixed(2);
    }

    if (value is num) {
      return value.toString();
    }

    if (value is bool) {
      return value ? 'Sí' : 'No';
    }

    return value.toString();
  }
}