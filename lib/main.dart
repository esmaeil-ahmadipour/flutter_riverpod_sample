import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/screens/home_screen.dart';
import 'package:flutter_riverpod_sample/features/main/locale/locale_providers.dart';
import 'package:flutter_riverpod_sample/features/main/theme/theme_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        return EasyLocalization(
          supportedLocales: languages,
          path: 'assets/localizations',
          fallbackLocale: ref.watch(localeProvider),
          useFallbackTranslations: true,
          child: const MyApp(),
        );
      }),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Multi-Theme Counter',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const HomeScreen(),
    );
  }
}
