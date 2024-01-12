import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../shared/components/components.dart';
import '../../../shared/enums/enums.dart';
import '../components/custom_month_selector.dart';
import 'providers.dart';

/// [OnChangeNotifier] exposes methods to change providers for dateTime and dateFormat
/// [DisplayChartsNotifier] holds the list to show BaseChartViewers for chart viewing
/// ChartViewers use methods in [ChartNotifier]
/// [ChartNotifier] use widgets in [chart_widgets]

final onChangeProvider = NotifierProvider<OnChangeNotifier, Null>(
  () => OnChangeNotifier(),
);

class OnChangeNotifier extends Notifier<Null> {
  @override
  build() {
    return null;
  }

  void onDropdownChanged(String? key, BuildContext context) {
    final dateTimeNotifier = ref.read(dateTimeProvider.notifier);
    final dateFormatNotifier = ref.read(dateFormatProvider.notifier);

    /// Change title date for dropdown
    final DropdownDate? value = dateKeyValues[key];

    ref.read(dropdownDateProvider.notifier).update((state) => value!);

    /// Change title date for chart
    if (value == DropdownDate.thisWeek) {
      dateFormatNotifier.update((state) => DateFormat('dd/MM/yyyy'));
      dateTimeNotifier.update(
        (state) => (
          start: Jiffy.now().subtract(weeks: 1).add(days: 1).dateTime,
          end: Jiffy.now().dateTime,
        ),
      );
    } else if (value == DropdownDate.lastWeek) {
      dateFormatNotifier.update((state) => DateFormat('dd/MM/yyyy'));
      dateTimeNotifier.update(
        (state) => (
          start: Jiffy.now().subtract(weeks: 2).add(days: 1).dateTime,
          end: Jiffy.now().subtract(weeks: 1).dateTime,
        ),
      );
    } else if (value == DropdownDate.thisMonth) {
      dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
      dateTimeNotifier.update((state) => (start: null, end: DateTime.now()));
    } else if (value == DropdownDate.lastMonth) {
      dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
      dateTimeNotifier.update(
        (state) => (start: null, end: Jiffy.now().subtract(months: 1).dateTime),
      );
    } else if (value == DropdownDate.thisYear) {
      dateFormatNotifier.update((state) => DateFormat('yyyy'));
      dateTimeNotifier.update(
        (state) => (start: null, end: Jiffy.now().dateTime),
      );
    } else if (value == DropdownDate.custom) {
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

  void onPickerSelectionChanged(DateRangePickerSelectionChangedArgs args) {
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

  void onCalendarOkPressed(BuildContext context) {
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

      ref.read(displayChartsProvider.notifier).addCharts();
    } else {
      ref.read(showErrorProvider.notifier).update((state) => true);
    }
  }
}
