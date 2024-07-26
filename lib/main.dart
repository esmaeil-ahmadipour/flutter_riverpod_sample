import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

final counterProvider = StateProvider<int>((ref) => 0);

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setInt('themeMode', 2);
    } else {
      state = ThemeMode.light;
      await prefs.setInt('themeMode', 1);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    late String languageCode;
    late String countryCode;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      languageCode = prefs.getString('languageCode') ?? 'en';
      countryCode = prefs.getString('countryCode') ?? 'US';
    }
    if (prefs.getString('languageCode') == 'en') {
      languageCode = prefs.getString('languageCode') ?? 'en';
      countryCode = prefs.getString('countryCode') ?? 'US';
    }
    if (prefs.getString('languageCode') == 'fa') {
      languageCode = prefs.getString('languageCode') ?? 'fa';
      countryCode = prefs.getString('countryCode') ?? 'IR';
    }
    state = Locale(languageCode, countryCode);
  }

  Future<void> setLocale(Locale locale) async {
    await Future.delayed(const Duration(milliseconds: 50), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', locale.languageCode);
      await prefs.setString('countryCode', locale.countryCode ?? '');
      state = locale;
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        return EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: themeNotifier.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () async {
              await localeNotifier.setLocale(await context.getSwitchedLocale());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('message'.tr()),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        tooltip: 'increment'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on BuildContext {
  Future<Locale> getSwitchedLocale() async {
    final newLocale = locale.languageCode == 'en'
        ? const Locale('fa', 'IR')
        : const Locale('en', 'US');

    await Future.delayed(const Duration(milliseconds: 50), () {
      setLocale(newLocale);
    });

    return newLocale;
  }
}
