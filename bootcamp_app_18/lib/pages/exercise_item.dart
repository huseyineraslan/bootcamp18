import 'package:flutter/material.dart';

class ExerciseItem extends StatefulWidget {
  final String exercise;

  const ExerciseItem({required this.exercise, super.key});

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  bool _completed = false;
  bool _skipped = false;

  void _handleCompletion(BuildContext context) {
    setState(() {
      _completed = true;
      _skipped = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tebrikler 🎉')),
    );
  }

  void _handleSkipping(BuildContext context) {
    setState(() {
      _completed = false;
      _skipped = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Egzersizleri kaçırma 😒')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.exercise),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: _completed || _skipped
                  ? null
                  : () => _handleCompletion(context),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: _completed || _skipped
                  ? null
                  : () => _handleSkipping(context),
            ),
          ],
        ),
      ],
    );
  }
}
