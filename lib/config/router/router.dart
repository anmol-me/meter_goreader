import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meter_reader/features/add_new/screens/add_new_screen.dart';
import 'package:meter_reader/features/home/screens/home_screen.dart';
import 'package:meter_reader/features/navigation/screens/navigation_screen.dart';
import 'package:meter_reader/features/readings/screens/readings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/navigation',
  routes: [
    GoRoute(
      path: '/navigation',
      pageBuilder: (context, state) => const MaterialPage(
        child: NavigationScreen(),
      ),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/add_new',
      pageBuilder: (context, state) => const MaterialPage(
        child: AddNewScreen(),
      ),
    ),
    GoRoute(
      path: '/readings',
      pageBuilder: (context, state) => const MaterialPage(
        child: ReadingsScreen(),
      ),
    ),
  ],
);
