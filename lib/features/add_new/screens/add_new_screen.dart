import 'package:flutter/material.dart';

class AddNewScreen extends StatelessWidget {
  const AddNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Reading',
          style: TextStyle(color: Colors.blueGrey.shade900),
        ),
        leading: const BackButton(),
      ),
    );
  }
}
