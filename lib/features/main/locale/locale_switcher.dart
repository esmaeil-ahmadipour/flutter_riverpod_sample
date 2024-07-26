import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:flutter_riverpod_sample/features/main/locale/locale_providers.dart';

class LocaleSwitcher extends ConsumerWidget {
  const LocaleSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeProvider.notifier);

    return DropdownButton<Locale>(
      value: ref.watch(localeProvider),
      onChanged: (Locale? newLocale) async {
        if (newLocale != null) {
          await Future.delayed(const Duration(milliseconds: 50), () {
            context.setLocale(newLocale);
          });
          await Future.delayed(const Duration(milliseconds: 50), () async {
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
    );
  }
}
