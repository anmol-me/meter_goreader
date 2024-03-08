import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/providers.dart';

sealed class BaseChartViewer extends ConsumerWidget {
  const BaseChartViewer({
    super.key,
    required this.selectedDate,
    required this.dateText,
    required this.unitsConsumedByDate,
  });

  final String dateText;
  final DateTime selectedDate;
  final Map<DateTime, int> unitsConsumedByDate;

  @override
  Widget build(BuildContext context, WidgetRef ref);
}

class ChartViewerForMonth extends BaseChartViewer {
  const ChartViewerForMonth({
    super.key,
    required super.selectedDate,
    required super.dateText,
    required super.unitsConsumedByDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartNotifier = ref.watch(chartProvider.notifier);

    return Container(
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
              dateText,
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
                barTouchData: chartNotifier.barTouchData,
                titlesData: chartNotifier.titlesData(),
                borderData: chartNotifier.borderData,
                barGroups: chartNotifier.barGroupsForMonth(
                  unitsConsumedByDate,
                  selectedDate,
                ),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartViewerForYear extends BaseChartViewer {
  const ChartViewerForYear({
    super.key,
    required super.selectedDate,
    required super.dateText,
    required super.unitsConsumedByDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartNotifier = ref.watch(chartProvider.notifier);

    return Container(
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
              dateText,
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
                barTouchData: chartNotifier.barTouchData,
                titlesData: chartNotifier.titlesData(),
                borderData: chartNotifier.borderData,
                barGroups: chartNotifier.barGroupsForYear(
                  unitsConsumedByDate,
                  selectedDate,
                ),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 1200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartViewerForWeek extends BaseChartViewer {
  const ChartViewerForWeek({
    super.key,
    required super.selectedDate,
    required super.dateText,
    required super.unitsConsumedByDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartNotifier = ref.watch(chartProvider.notifier);

    return Container(
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
              dateText,
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
                barTouchData: chartNotifier.barTouchData,
                titlesData: chartNotifier.titlesData(),
                borderData: chartNotifier.borderData,
                barGroups: chartNotifier.barGroupsForWeek(
                  unitsConsumedByDate,
                  selectedDate,
                ),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
