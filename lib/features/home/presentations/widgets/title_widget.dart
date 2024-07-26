import 'package:flutter/material.dart';
import 'package:flutter_riverpod_sample/core/utils/gen/localization/localization.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(LocaleKeys.app_title.tr());
  }
}
