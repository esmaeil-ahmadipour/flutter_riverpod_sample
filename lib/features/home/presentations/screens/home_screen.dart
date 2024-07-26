import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:flutter_riverpod_sample/core/utils/gen/localization/locale_keys.g.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/widgets/increment_button.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/widgets/number_widget.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/widgets/title_widget.dart';
import 'package:flutter_riverpod_sample/features/main/locale/locale_switcher.dart';
import 'package:flutter_riverpod_sample/features/main/theme/presentations/widget/theme_switcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: TitleWidget(),
        actions: [
          const ThemeSwitcher(),
          LocaleSwitcher(
            ctx: context,
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumberWidget(),
          ],
        ),
      ),
      floatingActionButton: const IncrementButton(),
    );
  }
}
