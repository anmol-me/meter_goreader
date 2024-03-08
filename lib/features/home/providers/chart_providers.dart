import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:meter_reader/features/home/providers/home_providers.dart';

import '../../../shared/enums/enums.dart';
import '../components/components.dart';

final chartProvider = NotifierProvider<ChartNotifier, Null>(
  () => ChartNotifier(),
);

class ChartNotifier extends Notifier<Null> {
  @override
  build() {
    return null;
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

  FlTitlesData titlesData() {
    final chartType = ref.read(chartTypeProvider);

    double interval = 10;
    if (chartType == ChartType.isYear) {
      interval = 100;
    } else if (chartType == ChartType.isMonth) {
      interval = 10;
    } else if (chartType == ChartType.isWeek) {
      interval = 10;
    }

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (val, meta) => getXTitles(val, meta, ref),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 37,
          getTitlesWidget: (val, meta) => getYTitles(val, meta, ref),
          interval: interval,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> barGroupsForMonth(
    Map<DateTime, int> unitsConsumedByDate,
    DateTime selectedDate,
  ) {
    final numberOfDays = Jiffy.parseFromDateTime(selectedDate).daysInMonth;

    final days = List.generate(
      numberOfDays,
      (index) => index + 1,
    );

    return days.map((day) {
      final date = DateTime(selectedDate.year, selectedDate.month, day);
      final consumedUnits = unitsConsumedByDate[date] ?? 0;

      return BarChartGroupData(
        x: day,
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

  List<BarChartGroupData> barGroupsForWeek(
    Map<DateTime, int> unitsConsumedByDate,
    DateTime selectedDate,
  ) {
    final weekDates = ref.read(dateTimeProvider);
    final firstWeekDate = weekDates.start!;
    final lastWeekDate = weekDates.end;

    List<DateTime> weekDays = List.generate(
      lastWeekDate.difference(firstWeekDate).inDays + 1,
      (index) {
        final weekDays = firstWeekDate.add(Duration(days: index));
        return DateTime(weekDays.year, weekDays.month, weekDays.day);
      },
    );

    Map<DateTime, int> unitsConsumedByDay = {};
    for (final weekDay in weekDays) {
      unitsConsumedByDay[weekDay] = 0;
    }

    for (final entry in unitsConsumedByDate.entries) {
      final date = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (unitsConsumedByDay.containsKey(date)) {
        unitsConsumedByDay[date] = entry.value;
      }
    }

    return weekDays.map((weekDay) {
      final unitsConsumed = unitsConsumedByDay[weekDay];

      return BarChartGroupData(
        x: weekDays.indexOf(weekDay),
        barRods: [
          BarChartRodData(
            toY: unitsConsumed!.toDouble(),
            color: Colors.green,
            width: 20,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  List<BarChartGroupData> barGroupsForYear(
    Map<DateTime, int> unitsConsumedByDate,
    DateTime selectedDate,
  ) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    Map<String, int> unitsConsumedByMonth = {};
    for (final month in months) {
      unitsConsumedByMonth[month] = 0;
    }

    for (final entry in unitsConsumedByDate.entries) {
      // Add month data for selected year
      if (entry.key.year == selectedDate.year) {
        final monthName = months[entry.key.month - 1];
        unitsConsumedByMonth[monthName] =
            unitsConsumedByMonth[monthName]! + entry.value;
      }
    }

    return months.map((month) {
      final unitsConsumed = unitsConsumedByMonth[month];

      return BarChartGroupData(
        x: months.indexOf(month),
        barRods: [
          BarChartRodData(
            toY: unitsConsumed!.toDouble(),
            color: Colors.green,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
