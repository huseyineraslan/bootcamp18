import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  NutritionPage({super.key});
  final List<IconData> healthyIcons = [
    Icons.apple,
    Icons.local_dining,
    Icons.kitchen,
    Icons.emoji_food_beverage,
    Icons.set_meal,
    Icons.ramen_dining,
    Icons.free_breakfast,
    Icons.egg,
    Icons.icecream,
    Icons.cake
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Beslenme'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildIcons(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                GradientButton(
                  text: 'Yapay Zeka Destekli Diyet Asistanı',
                  onPressed: () {
                    Navigator.pushNamed(context, '/aiAssistant');
                  },
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text:
                      'Vücut Kitle Endeksi Hesaplayarak \n Ne Yapman Gerektiğini Öğren',
                  onPressed: () {
                    Navigator.pushNamed(context, '/statistics');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcons(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    const double iconSize = 28;
    const double padding = 20;

    final int cols = (width / (iconSize + padding)).floor() + 1;
    final int rows = (height / (iconSize + padding)).floor() + 1;

    final List<Widget> icons = [];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final double top = row * (iconSize + padding);
        final double left = col * (iconSize + padding);
        final IconData icon =
            healthyIcons[(row * cols + col) % healthyIcons.length];
        icons.add(Positioned(
          top: top,
          left: left,
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.3),
            size: iconSize,
          ),
        ));
      }
    }

    return Stack(children: icons);
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
            style: Theme.of(context).textTheme.bodyLarge,

            ),
          ),
        ),

    );
  }
}
