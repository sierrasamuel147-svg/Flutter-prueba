import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../features/history/diagnostic_history_service.dart';
import 'diagnostic_history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final DiagnosticHistoryService historyService =
      DiagnosticHistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        centerTitle: true,
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: historyService.getDiagnosticHistory(),
        builder: (context, snapshot) {
          // =====================================================
          // CARGANDO
          // =====================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =====================================================
          // ERROR
          // =====================================================

          if (snapshot.hasError) {
            return _buildError(
              context,
              snapshot.error,
            );
          }

          // =====================================================
          // SIN DATOS
          // =====================================================

          final documents =
              snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return _buildEmptyState(context);
          }

          // =====================================================
          // LISTA
          // =====================================================

          return ListView(
            physics:
                const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              30,
            ),
            children: [
              _buildHeader(
                context,
                documents.length,
              ),

              const SizedBox(height: 24),

              ...documents.map(
                (document) {
                  return _buildDiagnosticCard(
                    context,
                    document,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    int total,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Tus diagnósticos',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          total == 1
              ? 'Has realizado 1 diagnóstico'
              : 'Has realizado $total diagnósticos',
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
  // TARJETA DE DIAGNÓSTICO
  // ============================================================

  Widget _buildDiagnosticCard(
    BuildContext context,
    QueryDocumentSnapshot<
        Map<String, dynamic>> document,
  ) {
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

    final Timestamp? timestamp =
        data['createdAt'] as Timestamp?;

    final DateTime? date =
        timestamp?.toDate();

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
                ? 'Con avisos'
                : 'Todo correcto';

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              const Color(0xFFEDEEF5),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(24),

          // ====================================================
          // ABRIR DETALLE
          // ====================================================

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DiagnosticHistoryDetailScreen(
                  document: document,
                ),
              ),
            );
          },

          child: Padding(
            padding:
                const EdgeInsets.all(18),
            child: Column(
              children: [
                // =================================================
                // CABECERA
                // =================================================

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration:
                          BoxDecoration(
                        color:
                            statusColor
                                .withValues(
                          alpha: 0.11,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),
                      ),
                      child: Icon(
                        statusIcon,
                        color:
                            statusColor,
                        size: 27,
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Diagnóstico completo',
                            style:
                                TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            _formatDate(
                              date,
                            ),
                            style:
                                TextStyle(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 36,
                      height: 36,
                      decoration:
                          BoxDecoration(
                        color: statusColor
                            .withValues(
                          alpha: 0.08,
                        ),
                        shape:
                            BoxShape.circle,
                      ),
                      child:
                          Icon(
                        Icons
                            .arrow_forward_ios_rounded,
                        size: 15,
                        color:
                            statusColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // ESTADO
                // =================================================

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        statusColor
                            .withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        statusIcon,
                        size: 19,
                        color:
                            statusColor,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        statusText,
                        style:
                            TextStyle(
                          color:
                              statusColor,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '$successfulTests/'
                        '$totalTests',
                        style:
                            TextStyle(
                          color:
                              statusColor,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // =================================================
                // ESTADÍSTICAS
                // =================================================

                Row(
                  children: [
                    Expanded(
                      child:
                          _buildStat(
                        icon: Icons
                            .check_circle_outline_rounded,
                        value:
                            successfulTests,
                        label:
                            'Correctas',
                        color:
                            Colors.green,
                      ),
                    ),

                    Expanded(
                      child:
                          _buildStat(
                        icon: Icons
                            .warning_amber_rounded,
                        value:
                            warningTests,
                        label:
                            'Avisos',
                        color:
                            Colors.orange,
                      ),
                    ),

                    Expanded(
                      child:
                          _buildStat(
                        icon: Icons
                            .cancel_outlined,
                        value:
                            failedTests,
                        label:
                            'Fallos',
                        color:
                            Colors.red,
                      ),
                    ),

                    if (unavailableTests >
                        0)
                      Expanded(
                        child:
                            _buildStat(
                          icon: Icons
                              .remove_circle_outline,
                          value:
                              unavailableTests,
                          label:
                              'No disp.',
                          color:
                              Colors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height: 14,
                ),

                // =================================================
                // INDICACIÓN
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Icon(
                      Icons
                          .touch_app_rounded,
                      size: 15,
                      color: Colors
                          .grey
                          .shade500,
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    Text(
                      'Toca para ver los detalles',
                      style:
                          TextStyle(
                        fontSize: 11,
                        color: Colors
                            .grey
                            .shade500,
                        fontWeight:
                            FontWeight
                                .w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ESTADÍSTICA
  // ============================================================

  Widget _buildStat({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),

        const SizedBox(height: 5),

        Text(
          '$value',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8A8EA3),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ESTADO VACÍO
  // ============================================================

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                shape:
                    BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 48,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              'Todavía no hay diagnósticos',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              'Cuando completes un diagnóstico, '
              'aparecerá aquí automáticamente.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
    BuildContext context,
    Object? error,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 70,
              color: Colors.orange,
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'No se pudo cargar el historial',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              'Comprueba tu conexión a Internet '
              'e inténtalo nuevamente.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ENTEROS
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

  // ============================================================
  // FECHA
  // ============================================================

  String _formatDate(
    DateTime? date,
  ) {
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
}