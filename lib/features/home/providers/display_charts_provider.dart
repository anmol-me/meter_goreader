import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meter_reader/features/home/providers/providers.dart';

import '../../../shared/enums/enums.dart';
import '../components/components.dart';

final displayChartsProvider =
    NotifierProvider<DisplayChartsNotifier, List<BaseChartViewer>>(
  () => DisplayChartsNotifier(),
);

class DisplayChartsNotifier extends Notifier<List<BaseChartViewer>> {
  late DropdownDate? dropdownDate;

  late ({String? startDate, String endDate}) dateText;

  late Map<DateTime, int> unitsConsumedByDate;

  late StateController<({DateTime end, DateTime? start})> dateTimeNotifier;

  late StateController<DateFormat> dateFormatNotifier;

  @override
  List<BaseChartViewer> build() {
    dropdownDate = ref.watch(dropdownDateProvider);
    dateText = ref.watch(dateTextProvider);
    unitsConsumedByDate = ref.watch(unitsConsumedByDateProvider);
    dateTimeNotifier = ref.watch(dateTimeProvider.notifier);
    dateFormatNotifier = ref.watch(dateFormatProvider.notifier);

    return [];
  }

  void addCharts() {
    if (dropdownDate == DropdownDate.thisMonth) {
      state = [
        ChartViewerForMonth(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    } else if (dropdownDate == DropdownDate.lastMonth) {
      state = [
        ChartViewerForMonth(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    } else if (dropdownDate == DropdownDate.thisWeek) {
      state = [
        ChartViewerForWeek(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    } else if (dropdownDate == DropdownDate.lastWeek) {
      state = [
        ChartViewerForWeek(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    } else if (dropdownDate == DropdownDate.thisYear) {
      state = [
        ChartViewerForYear(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    } else if (dropdownDate == DropdownDate.custom) {
      state = [
        ChartViewerForMonth(
          dateText: dateText.startDate!,
          selectedDate: ref.read(dateTimeProvider).start!,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
        ChartViewerForMonth(
          dateText: dateText.endDate,
          selectedDate: ref.read(dateTimeProvider).end,
          unitsConsumedByDate: unitsConsumedByDate,
        ),
      ];
    }
  }
}
