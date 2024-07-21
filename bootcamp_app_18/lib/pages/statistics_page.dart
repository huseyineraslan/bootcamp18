import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  double _bmi = 0;
  double _calorieNeeds = 0;
  double _bmr = 0;
  String _bmiCategory = "";

  void _calculateStats() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final int age = int.tryParse(_ageController.text) ?? 0;

    if (height > 0 && weight > 0 && age > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
        _bmr = 10 * weight + 6.25 * height - 5 * age + 5; // Erkekler için
        _calorieNeeds =
            _bmr * 1.2; // Hafif aktif (hareketsiz) aktivite seviyesi

        _bmiCategory = _getBmiCategory(_bmi);
      });
    }
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return "Zayıf";
    } else if (bmi < 24.9) {
      return "Normal kilolu";
    } else if (bmi < 29.9) {
      return "Fazla kilolu";
    } else if (bmi < 34.9) {
      return "1. Derece obez";
    } else if (bmi < 39.9) {
      return "2. Derece obez";
    } else {
      return "3. Derece obez (Morbid obez)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İstatistikler'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Boy (cm)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.height),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Kilo (kg)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Yaş',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calculateStats,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: Text(
                          'Hesapla',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fitness_center,
                              size: 40, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            'Vücut Kitle Endeksi: ${_bmi.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.assessment, size: 40, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            'Durum: $_bmiCategory',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 40, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            'Kalori İhtiyacı: ${_calorieNeeds.toStringAsFixed(2)} kcal',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.flash_on, size: 40, color: Colors.orange),
                          SizedBox(width: 10),
                          Text(
                            'Bazal Metabolizma: ${_bmr.toStringAsFixed(2)} kcal',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

