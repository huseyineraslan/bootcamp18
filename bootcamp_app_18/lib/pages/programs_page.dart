import 'package:flutter/material.dart';
import 'easy_page.dart';
import 'medium_page.dart';
import 'hard_page.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgramButton(
            title: 'Başlangıç Düzeyinde Egzersiz',
            gradient: const LinearGradient(
              colors: [Colors.yellow, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EasyProgramPage()),
              );
            },
          ),
          ProgramButton(
            title: 'Orta Düzeyde Egzersiz',
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MediumProgramPage()),
              );
            },
          ),
          ProgramButton(
            title: 'Zor Düzeyde Egzersiz',
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HardProgramPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProgramButton extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final VoidCallback onPressed;

  const ProgramButton({
    required this.title,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 150, // Butonların boyutunu büyütüyorum
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
