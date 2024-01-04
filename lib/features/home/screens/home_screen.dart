import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

final selectedGraphDateProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGraphDate = ref.watch(selectedGraphDateProvider);

    final dateFormat = DateFormat('MMMM yyyy');
    int selectedMonth = 1;
    int selectedYear = 2024;
    DateTime selectedDate = DateTime(selectedYear, selectedMonth);
    String formattedDate = dateFormat.format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
        actions: [
          SizedBox(
            width: 150,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 10),
                      Text(selectedGraphDate ?? 'This Month'),
                    ],
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 7,
                        spreadRadius: 7,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: SizedBox.shrink(),
                ),
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                items: items,
                onChanged: (value) {
                  final keyValueText = dateKeyValues[value];

                  ref
                      .read(selectedGraphDateProvider.notifier)
                      .update((state) => keyValueText!);
                },
              ),
            ),
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
                      formattedDate,
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
                        barGroups: barGroups,
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

List<BarChartGroupData> get barGroups {
  List listOfDays = [];

  const year = 2024;
  const month = 1; // January

  final desiredDate = DateTime(year, month + 1, 0);
  final numberOfDays = desiredDate.day;

  for (int i = 0; i < numberOfDays; i++) {
    listOfDays.add(i);
  }

  return listOfDays
      .map((e) => BarChartGroupData(
            x: e,
            barRods: [
              BarChartRodData(
                toY: Random().nextInt(55).toDouble(),
                color: Colors.green,
              )
            ],
            showingTooltipIndicators: [0],
          ))
      .toList();
}

final dateKeyValues = {
  'item1': 'This Week',
  'item2': 'Last Week',
  'item3': 'This Month',
  'item4': 'Last Month',
  'item5': 'This Year',
  'item6': 'Custom',
};

List<DropdownMenuItem<String>> items = dateKeyValues.entries
    .map(
      (entry) => DropdownMenuItem(
        value: entry.key,
        child: Text(entry.value),
      ),
    )
    .toList();
