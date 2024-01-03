import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [],
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
                    margin:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: const Text(
                      'January 2024',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                        maxY: 20,
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

  const style = TextStyle(
    color: Colors.black,
    fontSize: 10,
  );

  String text;

  // Set the text value directly based on the current value (day index)
  text = value < 1 ? '' : value.toString();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: Text(text, style: style),
  );
}

Widget getYTitles(double val, TitleMeta meta) {
  final value = val.toInt();
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String text;

  switch (value) {
    case 0:
      text = '0';
      break;
    case 5:
      text = '5';
      break;
    case 10:
      text = '10';
      break;
    case 15:
      text = '15';
      break;
    case 20:
      text = '20';
      break;
    // case 5:
    //   text = '5';
    //   break;
    // case 6:
    //   text = '6';
    //   break;
    default:
      text = '0';
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 12,
    child: Text(text, style: style),
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
                toY: Random().nextInt(18).toDouble(),
                color: Colors.green,
              )
            ],
            showingTooltipIndicators: [0],
          ))
      .toList();
}
