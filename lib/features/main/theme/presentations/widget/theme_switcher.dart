import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/main/theme/theme_providers.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);

    return IconButton(
      icon: const Icon(Icons.brightness_6),
      onPressed: themeNotifier.toggleTheme,
    );
  }
}
