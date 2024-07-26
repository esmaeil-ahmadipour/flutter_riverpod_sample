import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/features/home/presentations/submodule/counter/counter_provider.dart';

class IncrementButton extends ConsumerWidget {
  const IncrementButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final increment = ref.read(counterProvider.notifier);
    return FloatingActionButton(
      onPressed: () => increment.state++,
      child: const Icon(Icons.add),
    );
  }
}
