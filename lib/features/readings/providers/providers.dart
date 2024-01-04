import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../modals/reading.dart';

final readingsProvider = StateProvider(
      (ref) => [
    const Reading(
      onDate: 'Today',
      morningReading: '23123',
      eveningReading: null,
      date: '01-01-2024',
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    const Reading(
      onDate: 'Yesterday',
      morningReading: '23123',
      eveningReading: '23123',
      date: '01-01-2024',
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    const Reading(
      onDate: 'Saturday',
      morningReading: '23123',
      eveningReading: '23123',
      date: '01-01-2024',
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
    const Reading(
      onDate: 'Friday',
      morningReading: '23123',
      eveningReading: '23123',
      date: '01-01-2024',
      morningTime: '08:23 AM',
      eveningTime: '08:23 AM',
    ),
  ],
);