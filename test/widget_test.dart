import 'package:flutter_test/flutter_test.dart';
import 'package:cuida_papai/main.dart';
import 'package:cuida_papai/core/service_locator.dart';

void main() {
  testWidgets('App UI load test', (WidgetTester tester) async {
    // Configura os serviços antes de rodar o teste
    setupLocator();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const CuidaPapaiApp());

    // Verify that the HomeScreen title is rendered.
    expect(find.text('Início'), findsOneWidget);
  });
}
