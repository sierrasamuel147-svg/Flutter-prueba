import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiagnosticStatus extends StatelessWidget {
  final bool success;
  final String title;
  final String message;
  final Color? color;

  const DiagnosticStatus({
    super.key,
    required this.success,
    required this.title,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        color ??
        (success
            ? AppTheme.success
            : AppTheme.primary);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: statusColor.withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            success
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            color: statusColor,
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    color: statusColor,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    color:
                        AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}