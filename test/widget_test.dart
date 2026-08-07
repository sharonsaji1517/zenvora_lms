// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zenvoraapp/main.dart';
import 'package:zenvoraapp/viewmodels/app_settings_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app with AppSettingsProvider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
        child: const ZenvoraApp(),
      ),
    );

    // Verify that the app builds without crashing and advance splash timer.
    expect(find.byType(ZenvoraApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
