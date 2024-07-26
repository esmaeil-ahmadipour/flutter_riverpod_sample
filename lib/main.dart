import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:flutter_riverpod_sample/core/utils/gen/localization/codegen_loader.g.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/screens/home_screen.dart';
import 'package:flutter_riverpod_sample/features/main/theme/theme_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: Builder(builder: (context) {
        return EasyLocalization(
            saveLocale: true,
            useFallbackTranslations: true,
            supportedLocales: languages,
            fallbackLocale: languages.first,
            path: 'assets/localizations',
            assetLoader: const CodegenLoader(),
            child: MyApp());
      }),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Multi-Theme Counter',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.savedLocale ?? context.locale,
      home: const HomeScreen(),
    );
  }
}
