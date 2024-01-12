import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/enums/enums.dart';
import '../../readings/providers/providers.dart';

final showErrorProvider = StateProvider.autoDispose((ref) => false);

final dropdownDateProvider =
    StateProvider<DropdownDate?>((ref) => DropdownDate.thisMonth);

final dateFormatProvider = StateProvider<DateFormat>(
  (ref) => DateFormat('MMMM yyyy'),
);

final dateTimeProvider = StateProvider<({DateTime? start, DateTime end})>(
  (ref) => (start: DateTime.now(), end: DateTime.now()),
);

final customMonthProvider = StateProvider<({DateTime? start, DateTime end})>(
  (ref) => (start: DateTime.now(), end: DateTime.now()),
);

final formattedDateProvider =
    StateProvider<({String? startDate, String endDate})>((ref) {
  final formatter = ref.watch(dateFormatProvider);
  final dateTime = ref.watch(dateTimeProvider);

  final formattedDateStart = formatter.format(dateTime.start ?? DateTime.now());
  final formattedDateEnd = formatter.format(dateTime.end);
  return (startDate: formattedDateStart, endDate: formattedDateEnd);
});

final dateTextProvider = Provider<({String? startDate, String endDate})>((ref) {
  final chartType = ref.watch(chartTypeProvider);
  final formattedDate = ref.watch(formattedDateProvider);

  ({String? startDate, String endDate}) display = (
    startDate: formattedDate.startDate,
    endDate: formattedDate.endDate,
  );

  if (chartType == ChartType.isWeek) {
    display = (
      startDate: null,
      endDate: 'Week ${formattedDate.startDate} - ${formattedDate.endDate}',
    );
  } else if (chartType == ChartType.isYear) {
    display = (
      startDate: null,
      endDate: 'Year ${formattedDate.endDate}',
    );
  } else if (chartType == ChartType.isMonth) {
    display = (
      startDate: '${formattedDate.startDate}',
      endDate: (formattedDate.endDate),
    );
  }
  return display;
});

final chartTypeProvider = StateProvider((ref) {
  final dropdownValue = ref.watch(dropdownDateProvider);

  ChartType chartType = ChartType.isMonth;

  if (dropdownValue == DropdownDate.thisYear) {
    chartType = ChartType.isYear;
  } else if (dropdownValue == DropdownDate.thisMonth ||
      dropdownValue == DropdownDate.lastMonth ||
      dropdownValue == DropdownDate.custom) {
    chartType = ChartType.isMonth;
  } else if (dropdownValue == DropdownDate.thisWeek ||
      dropdownValue == DropdownDate.lastWeek) {
    chartType = ChartType.isWeek;
  }

  return chartType;
});

final unitsConsumedByDateProvider = StateProvider((ref) {
  final readings = ref.watch(readingsProvider);

  final Map<DateTime, int> unitsConsumedByDate = {};

  for (final reading in readings) {
    final consumed = reading.eveningReading - reading.morningReading;
    if (consumed >= 0) {
      unitsConsumedByDate[reading.date] = consumed;
    }
  }
  return unitsConsumedByDate;
});
