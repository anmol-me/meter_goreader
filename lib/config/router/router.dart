import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meter_reader/features/home/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(
        child: HomeScreen(),
      ),
    ),
  ],
);
