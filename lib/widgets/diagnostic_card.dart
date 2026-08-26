import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiagnosticCard
    extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DiagnosticCard({
    super.key,
    required this.child,
    this.padding =
        const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: child,
    );
  }
}