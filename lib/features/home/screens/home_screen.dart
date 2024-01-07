import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:meter_reader/features/readings/providers/providers.dart';
import '../../../shared/components/custom_dropdown_button.dart';

/// Providers
final dropdownDateProvider = StateProvider<ShowDate?>((ref) => null);

final dateFormatProvider = StateProvider<DateFormat>(
  (ref) => DateFormat('MMMM yyyy'),
);

final dateTimeProvider = StateProvider<({DateTime? start, DateTime end})>(
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

///

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChartDate = ref.watch(dropdownDateProvider);
    final unitsConsumedByDate = ref.watch(unitsConsumedByDateProvider);

    final showDateText = ref.watch(showDateTextProvider);

    final dateTimeNotifier = ref.read(dateTimeProvider.notifier);
    final dateFormatNotifier = ref.read(dateFormatProvider.notifier);

    void onChanged(String? key) {
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
          (state) =>
              (start: null, end: Jiffy.now().subtract(months: 1).dateTime),
        );
      } else if (value == ShowDate.thisYear) {
        dateFormatNotifier.update((state) => DateFormat('yyyy'));
        dateTimeNotifier.update(
          (state) => (start: null, end: Jiffy.now().dateTime),
        );
      } else if (value == ShowDate.custom) {
        dateFormatNotifier.update((state) => DateFormat('MMMM'));
        dateTimeNotifier.update((state) => (
              start: Jiffy.now().subtract(months: 1).dateTime,
              end: Jiffy.now().dateTime,
            ));
      } else {
        dateFormatNotifier.update((state) => DateFormat('MMMM yyyy'));
        dateTimeNotifier.update((state) => (start: null, end: DateTime.now()));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
        actions: [
          CustomDropdownButton(
            selectedGraphDate: selectedChartDate?.value,
            onChanged: onChanged,
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      showDateText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        barTouchData: barTouchData,
                        titlesData: titlesData,
                        borderData: borderData,
                        barGroups: barGroups(unitsConsumedByDate, ref),
                        gridData: const FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            const TextStyle(
              color: Colors.transparent,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );

Widget getXTitles(double val, TitleMeta meta) {
  final value = val.toInt() + 1;

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: Text(
      value < 1 ? '' : value.toString(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    ),
  );
}

Widget getYTitles(double val, TitleMeta meta) {
  final value = val.toInt();
  String text;

  if (value % 5 == 0) {
    text = value.toString();
  } else {
    text = '';
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 12,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

FlTitlesData get titlesData => const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getXTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getYTitles,
          interval: 5,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(
      show: false,
    );

List<BarChartGroupData> barGroups(
  Map<DateTime, int> unitsConsumed,
  WidgetRef ref,
) {
  const year = 2024;
  const month = 1;

  final desiredDate = DateTime(year, month + 1, 0);
  // final desiredDate = ref.read(dateTimeProvider);

  final numberOfDays = desiredDate.day;

  final days = List.generate(
    numberOfDays,
    (index) => index + 1,
  );

  return days.map((day) {
    final date = DateTime(year, month, day);
    final consumedUnits = unitsConsumed[date] ?? 0;

    return BarChartGroupData(
      x: day - 1,
      barRods: [
        BarChartRodData(
          toY: consumedUnits.toDouble(),
          color: Colors.green,
        )
      ],
      showingTooltipIndicators: [0],
    );
  }).toList();
}
