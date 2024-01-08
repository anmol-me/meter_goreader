import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/components/custom_dropdown_button.dart';
import '../../readings/providers/providers.dart';

final showErrorProvider = StateProvider.autoDispose((ref) => false);

final dropdownDateProvider = StateProvider<ShowDate?>((ref) => null);

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
    StateProvider<({String? start, String end})>((ref) {
  final formatter = ref.watch(dateFormatProvider);
  final dateTime = ref.watch(dateTimeProvider);

  final formattedDateStart = formatter.format(dateTime.start ?? DateTime.now());
  final formattedDateEnd = formatter.format(dateTime.end);
  return (start: formattedDateStart, end: formattedDateEnd);
});

final showDateTextProvider = Provider((ref) {
  final dropdownDate = ref.watch(dropdownDateProvider);
  final formattedDate = ref.watch(formattedDateProvider);

  String display = formattedDate.end;
  if (dropdownDate == ShowDate.thisWeek) {
    display = 'Week ${formattedDate.start} - ${formattedDate.end}';
  } else if (dropdownDate == ShowDate.lastWeek) {
    display = 'Week ${formattedDate.start} - ${formattedDate.end}';
  } else if (dropdownDate == ShowDate.thisYear) {
    display = 'Year ${formattedDate.end}';
  } else if (dropdownDate == ShowDate.custom) {
    display = '${formattedDate.start}';
  } else {
    display = formattedDate.end;
  }
  return display;
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
