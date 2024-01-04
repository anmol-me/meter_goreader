import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/components/app_search_bar.dart';
import '../components/text_bar_widgets.dart';
import '../providers/providers.dart';

class ReadingsScreen extends HookConsumerWidget {
  const ReadingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    final readings = ref.watch(readingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Readings',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: AppSearchBar(
                controller: searchController,
              ),
            ),

            // Text Blocks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: readings
                    .map((e) => TextBlock(
                          onDate: e.onDate,
                          morningReading: e.morningReading,
                          eveningReading: e.eveningReading,
                          date: e.date,
                          morningTime: e.morningTime,
                          eveningTime: e.eveningTime,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
