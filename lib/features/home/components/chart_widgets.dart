import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meter_reader/features/home/providers/home_providers.dart';

import '../../../shared/enums/enums.dart';

Widget getXTitles(double val, TitleMeta meta, ref) {
  final value = val.toInt();
  String text = value.toString();

  final chartType = ref.read(chartTypeProvider);

  if (chartType == ChartType.isYear) {
    text = switch (value) {
      0 => 'Jan',
      1 => 'Feb',
      2 => 'Mar',
      3 => 'Apr',
      4 => 'May',
      5 => 'Jun',
      6 => 'Jul',
      7 => 'Aug',
      8 => 'Sep',
      9 => 'Oct',
      10 => 'Nov',
      11 => 'Dec',
      _ => '',
    };
  } else if (chartType == ChartType.isWeek) {
    text = switch (value) {
      0 => 'Sun',
      1 => 'Mon',
      2 => 'Tues',
      3 => 'Wed',
      4 => 'Thurs',
      5 => 'Fri',
      6 => 'Sat',
      _ => '',
    };
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    ),
  );
}

Widget getYTitles(double val, TitleMeta meta) {
  final value = val.toInt();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 12,
    child: Text(
      value.toString(),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}
