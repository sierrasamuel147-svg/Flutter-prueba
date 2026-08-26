import 'diagnostic_status.dart';

class DiagnosticResult {
  final String component;
  final DiagnosticStatus status;
  final String message;
  final Map<String, dynamic> details;

  final DateTime testedAt;

  DiagnosticResult({
    required this.component,
    required this.status,
    required this.message,
    this.details = const {},
    DateTime? testedAt,
  }) : testedAt = testedAt ?? DateTime.now();

  bool get isSuccessful =>
      status == DiagnosticStatus.ok;

  bool get isAvailable =>
      status != DiagnosticStatus.unavailable;

  Map<String, dynamic> toMap() {
    return {
      'component': component,
      'status': status.name,
      'message': message,
      'details': details,
      'testedAt': testedAt.toIso8601String(),
    };
  }
}