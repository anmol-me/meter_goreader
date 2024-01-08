import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../shared/components/custom_dropdown_button.dart';
import '../components/custom_month_selector.dart';
import 'providers.dart';

final onChangeProvider = NotifierProvider<OnChangeNotifier, Null>(
  () => OnChangeNotifier(),
);

class OnChangeNotifier extends Notifier<Null> {
  @override
  build() {
    return null;
  }

  void onChanged(String? key, BuildContext context) {
    final dateTimeNotifier = ref.read(dateTimeProvider.notifier);
    final dateFormatNotifier = ref.read(dateFormatProvider.notifier);

    // Change title date for dropdown
    final ShowDate? value = dateKeyValues[key];

    ref.read(dropdownDateProvider.notifier).update((state) => value!);

    // Change title date for chart
    if (value == ShowDate.thisWeek) {
      dateFormatNotifier.update((state) => DateFormat('dd/MM/yyyy'));
      dateTimeNotifier.update(
        (state) => (
          start: Jiffy.now().subtract(weeks: 1).add(days: 1).dateTime,
          end: Jiffy.now().dateTime,
        ),
      );
    } else if (value == ShowDate.lastWeek) {
      dateFormatNotifier.update((state) => DateFormat('dd/MM/yyyy'));
      dateTimeNotifier.update(
        (state) => (
          start: Jiffy.now().subtract(weeks: 2).add(days: 1).dateTime,
          end: Jiffy.now().subtract(weeks: 1).dateTime,
        ),
      );
    } else if (value == ShowDate.thisMonth) {
      dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
      dateTimeNotifier.update((state) => (start: null, end: DateTime.now()));
    } else if (value == ShowDate.lastMonth) {
      dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
      dateTimeNotifier.update(
        (state) => (start: null, end: Jiffy.now().subtract(months: 1).dateTime),
      );
    } else if (value == ShowDate.thisYear) {
      dateFormatNotifier.update((state) => DateFormat('yyyy'));
      dateTimeNotifier.update(
        (state) => (start: null, end: Jiffy.now().dateTime),
      );
    } else if (value == ShowDate.custom) {
      showDialog(
        context: context,
        builder: (context) {
          return const CustomMonthSelector();
        },
      );
    } else {
      dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
      dateTimeNotifier.update((state) => (start: null, end: DateTime.now()));
    }
  }

  onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final customMonthNotifier = ref.read(customMonthProvider.notifier);

    if (args.value is PickerDateRange) {
      if (args.value.startDate != null && args.value.endDate != null) {
        final DateTime rangeStartDate = args.value.startDate;
        final DateTime rangeEndDate = args.value.endDate;

        customMonthNotifier.update((state) => (
              start: rangeStartDate,
              end: rangeEndDate,
            ));
      }
    }
  }

  onOkPressed(
    BuildContext context,
  ) {
    final customMonth = ref.read(customMonthProvider);
    final dateTimeNotifier = ref.read(dateTimeProvider.notifier);
    final dateFormatNotifier = ref.read(dateFormatProvider.notifier);

    final isBeforeToday =
        customMonth.end.isBefore(Jiffy.now().add(months: 1).dateTime);

    if (isBeforeToday) {
      Navigator.of(context).pop();

      dateFormatNotifier.update((state) => DateFormat('MMMM'));

      dateTimeNotifier.update(
        (state) => ref.read(customMonthProvider),
      );
    } else {
      ref.read(showErrorProvider.notifier).update((state) => true);
    }
  }
}
