import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prueba/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const PhoneDiagnosticApp());

    expect(find.text('Phone Diagnostic'), findsOneWidget);
    expect(find.text('Diagnóstico del dispositivo'), findsOneWidget);
    expect(find.text('Iniciar diagnóstico'), findsOneWidget);
  });
}