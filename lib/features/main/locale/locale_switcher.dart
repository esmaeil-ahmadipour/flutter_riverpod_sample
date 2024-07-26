import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';

class LocaleSwitcher extends StatelessWidget {
  const LocaleSwitcher({
    super.key,required this.ctx,
  });

  final BuildContext  ctx;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: ctx.locale,
      onChanged: (Locale? newLocale) async {
        if (newLocale != null) {
           await Future.delayed(const Duration(milliseconds: 50), () {
             ctx.deleteSaveLocale();
             ctx.setLocale(newLocale);
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
