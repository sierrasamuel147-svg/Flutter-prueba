import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/diagnostics/diagnostic_result.dart';

class DiagnosticHistoryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<void> saveDiagnostic(
    List<DiagnosticResult> results,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un usuario autenticado',
      );
    }

    final successfulTests = results
        .where(
          (result) =>
              result.status.name == 'ok',
        )
        .length;

    final warningTests = results
        .where(
          (result) =>
              result.status.name == 'warning',
        )
        .length;

    final failedTests = results
        .where(
          (result) =>
              result.status.name == 'failed',
        )
        .length;

    final unavailableTests = results
        .where(
          (result) =>
              result.status.name == 'unavailable',
        )
        .length;

    final notTestedTests = results
        .where(
          (result) =>
              result.status.name == 'notTested',
        )
        .length;

    final data = {
      'createdAt': FieldValue.serverTimestamp(),

      'totalTests': results.length,

      'successfulTests':
          successfulTests,

      'warningTests':
          warningTests,

      'failedTests':
          failedTests,

      'unavailableTests':
          unavailableTests,

      'notTestedTests':
          notTestedTests,

      'results': results.map(
        (result) {
          return {
            'component':
                result.component,

            'status':
                result.status.name,

            'message':
                result.message,

            'details':
                result.details,
          };
        },
      ).toList(),
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('diagnostics')
        .add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getDiagnosticHistory() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un usuario autenticado',
      );
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('diagnostics')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }
}