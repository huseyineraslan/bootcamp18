import 'package:flutter/material.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program'),
      ),
      body: const Center(
        child: Text(
          'Bu sayfa henüz yapılandırılmadı.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
