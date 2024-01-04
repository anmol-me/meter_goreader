import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../modals/reading.dart';

final readingsProvider = StateProvider(
  (ref) => [
    Reading(
      onDate: 'Today',
      morningReading: 23123,
      eveningReading: 0,
      date: DateTime(2024, 01, 01),
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    Reading(
      onDate: 'Yesterday',
      morningReading: 23123,
      eveningReading: 23133,
      date: DateTime(2024, 01, 02),
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    Reading(
      onDate: 'Saturday',
      morningReading: 23123,
      eveningReading: 23143,
      date: DateTime(2024, 01, 07),
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    Reading(
      onDate: 'Friday',
      morningReading: 23123,
      eveningReading: 23153,
      date: DateTime(2024, 01, 11),
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
  ],
);
