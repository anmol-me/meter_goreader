import 'package:flutter/material.dart';

class ReadingsScreen extends StatelessWidget {
  const ReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Readings',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
      ),
    );
  }
}
