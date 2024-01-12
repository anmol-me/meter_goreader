import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../providers/providers.dart';

class CustomMonthSelector extends ConsumerWidget {
  const CustomMonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showError = ref.watch(showErrorProvider);

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        height: showError ? 360 : 340,
        width: 500,
        child: Column(
          children: [
            SfDateRangePicker(
              view: DateRangePickerView.year,
              selectionMode: DateRangePickerSelectionMode.range,
              rangeSelectionColor: Colors.transparent,
              allowViewNavigation: false,
              onSelectionChanged: (args) =>
                  ref.read(onChangeProvider.notifier).onPickerSelectionChanged(args),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(onChangeProvider.notifier).onCalendarOkPressed(
                            context,
                          ),
                  child: const Text('OK'),
                ),
              ],
            ),
            showError
                ? Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text(
                      'Please select a date on or before today',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
