import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

const languages = [
  Locale('en', 'US'),
  Locale('fa', 'IR'),
  Locale('es', 'ES'),
  Locale('de', 'DE'),
  Locale('fr', 'FR'),
  Locale('it', 'IT'),
];

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
    String? languageCode;
    String? countryCode;
    final prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < languages.length; ++i) {
      var language = languages[i];
      if (prefs.getString('languageCode') == language.languageCode) {
        languageCode = prefs.getString('languageCode')!;
        countryCode = prefs.getString('countryCode')!;
        break;
      }
    }
    if (languageCode == null || countryCode == null) {
      languageCode = prefs.getString('languageCode') ?? languages[0].languageCode;
      countryCode = prefs.getString('countryCode') ?? languages[0].countryCode;
    }

    state = Locale(languageCode, countryCode);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode!);
    state = locale;
  }
}

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
          DropdownButton<Locale>(
            value: ref.watch(localeProvider),
            onChanged: (Locale? newLocale) async {
              if (newLocale != null) {
                await Future.delayed(const Duration(milliseconds: 50), () {
                  context.setLocale(newLocale);
                });
                await Future.delayed(const Duration(milliseconds: 50),
                    () async {
                  await localeNotifier.setLocale(newLocale);
                });
              }
            },
            items: languages.map((locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(locale.toLanguageTag()),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
