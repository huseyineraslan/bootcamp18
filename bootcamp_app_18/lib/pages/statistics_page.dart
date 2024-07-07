import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/exercise_detail/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BMIWidget(),
        ),
      ),
    );
  }
}

class BMIWidget extends StatefulWidget {
  const BMIWidget({Key? key}) : super(key: key);

  @override
  BMIWidgetState createState() => BMIWidgetState();
}

class BMIWidgetState extends State<BMIWidget> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmiResult;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Boy (metre cinsinden)',
              labelStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Kilo (kg cinsinden)',
              labelStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
          TextButton.icon(
            onPressed: () {
              _calculateBMI();
            },
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text('BMI Hesapla',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Bold stil eklendi
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          _bmiResult != null
              ? Text(
            'BMI: ${_bmiResult!.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 30.0, color: Colors.green, fontWeight: FontWeight.bold), // Bold stil eklendi
          )
              : Container(),
        ],
      ),
    );
  }

  void _calculateBMI() {
    double height = double.parse(_heightController.text);
    double weight = double.parse(_weightController.text);
    double heightSquared = height * height;
    double bmi = weight / heightSquared;
    setState(() {
      _bmiResult = bmi;
    });
  }
}
