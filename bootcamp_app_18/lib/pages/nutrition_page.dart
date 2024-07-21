import 'package:flutter/material.dart';
import 'ai_assistant_page.dart';
import 'statistics_page.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beslenme'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              GradientButton(
                text: 'Yapay Zeka Destekli Diyet Asistanı',
                onPressed: () {
                  Navigator.pushNamed(context, '/aiAssistant');
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Vücut Kitle Endeksi Hesaplayarak Ne Yapman Gerektiğini Öğren',
                onPressed: () {
                  Navigator.pushNamed(context, '/statistics');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
