import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';

/*
adım sayar denenmiştir ama henüz çalıştırılamamıştır daha sonra bak.
*/
class PedometerService with ChangeNotifier {
  int _stepCount = 0;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  PedometerService() {
    _initPedometer();
  }

  int get stepCount => _stepCount;

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
    _pedestrianStatusStream
        .listen(_onPedestrianStatusChanged)
        .onError(_onPedestrianStatusError);
  }

  void _onStepCount(StepCount event) {
    _stepCount = event.steps;
    notifyListeners();
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    print('Pedestrian Status: ${event.status}');
  }

  void _onPedestrianStatusError(error) {
    print('Pedestrian Status Error: $error');
  }
}
