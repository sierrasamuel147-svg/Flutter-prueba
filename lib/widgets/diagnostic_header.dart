import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiagnosticHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const DiagnosticHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(31),
            color: color.withValues(
              alpha: 0.10,
            ),
          ),
          child: Container(
            margin:
                const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(24),
              color: color.withValues(
                alpha: 0.15,
              ),
            ),
            child: Icon(
              icon,
              size: 48,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}