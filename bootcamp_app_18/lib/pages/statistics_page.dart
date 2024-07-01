import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
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
