import 'package:flutter/material.dart';

class TextBlock extends StatelessWidget {
  const TextBlock({
    super.key,
    required this.onDate,
    required this.morningReading,
    required this.eveningReading,
    required this.date,
    required this.morningTime,
    required this.eveningTime,
  });

  final String onDate;
  final String? morningReading;
  final String? eveningReading;
  final String date;
  final String morningTime;
  final String eveningTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                onDate,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextBar(
          dayTime: 'Morning',
          reading: morningReading,
          date: date,
          time: morningTime,
        ),
        const SizedBox(height: 12),
        TextBar(
          dayTime: 'Evening',
          reading: eveningReading,
          date: date,
          time: eveningTime,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(),
        ),
      ],
    );
  }
}

class TextBar extends StatelessWidget {
  const TextBar({
    super.key,
    required this.dayTime,
    required this.reading,
    required this.date,
    required this.time,
  });

  final String dayTime;
  final String? reading;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingTextBar(dayTime: dayTime, reading: reading),
        DateTimeTextBar(date: date, time: time),
      ],
    );
  }
}

class DateTimeTextBar extends StatelessWidget {
  const DateTimeTextBar({
    super.key,
    required this.date,
    required this.time,
  });

  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class HeadingTextBar extends StatelessWidget {
  const HeadingTextBar({
    super.key,
    required this.dayTime,
    required this.reading,
  });

  final String dayTime;
  final String? reading;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey.shade800,
      fontSize: 16,
    );

    if (reading == null) {
      textStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontSize: 16,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dayTime,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
        Text(
          reading ?? 'Pending',
          style: textStyle,
        ),
      ],
    );
  }
}
