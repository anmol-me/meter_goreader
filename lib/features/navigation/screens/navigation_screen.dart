import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meter_reader/features/add_new/screens/add_new_screen.dart';
import 'package:meter_reader/features/home/screens/home_screen.dart';
import 'package:meter_reader/features/readings/screens/readings_screen.dart';

final selectedNavItemProvider = StateProvider((ref) => 0);

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNavItem = ref.watch(selectedNavItemProvider);
    final selectedNavItemNotifier = ref.watch(selectedNavItemProvider.notifier);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade50,
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        currentIndex: selectedNavItem,
        items: _bottomNavigationBarItems,
        onTap: (int val) {
          selectedNavItemNotifier.update((state) => val);
        },
      ),
      body: _screens[selectedNavItem],
    );
  }
}

final _bottomNavigationBarItems = [
  const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New'),
  const BottomNavigationBarItem(
    icon: Icon(Icons.energy_savings_leaf_outlined),
    label: 'Readings',
  ),
];

final _screens = [
  const HomeScreen(),
  const AddNewScreen(),
  const ReadingsScreen(),
];
