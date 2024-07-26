import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:flutter_riverpod_sample/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
// Make sure WidgetsFlutterBinding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

// Simulate SharedPreferences for testing
  SharedPreferences.setMockInitialValues({});

// Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
// Create widget inside ProviderScope and EasyLocalization
    await tester.pumpWidget(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: languages,
          path: 'assets/localizations',
          fallbackLocale: const Locale('en', 'US'),
          useFallbackTranslations: true,
          child: const MyApp(),
        ),
      ),
    );

// Waiting for initial rendering
    await tester.pumpAndSettle();

    // Make sure counter is initialized to 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Click the '+' button and render a new frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

// Make sure the counter is incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
