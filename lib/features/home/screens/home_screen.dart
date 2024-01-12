import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/components.dart';
import '../../../shared/enums/enums.dart';
import '../providers/providers.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownValue = ref.watch(dropdownDateProvider);
    final displayChart = ref.watch(displayChartsProvider);

    useEffect(
      () {
        Future.delayed(Duration.zero).then((_) {
          return ref.read(displayChartsProvider.notifier).addCharts();
        });
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
        actions: [
          AppDropdownButton(
            selectedGraphDate: dropdownValue?.value,
            onChanged: (key) {
              ref
                  .read(onChangeProvider.notifier)
                  .onDropdownChanged(key, context);

              final dropdownValue = ref.read(dropdownDateProvider);
              if (dropdownValue != DropdownDate.custom) {
                ref.read(displayChartsProvider.notifier).addCharts();
              }
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: displayChart,
          ),
        ),
      ),
    );
  }
}
