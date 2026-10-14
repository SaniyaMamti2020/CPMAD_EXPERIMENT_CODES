import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorSection extends StatefulWidget {
  const SensorSection({super.key});

  @override
  State<SensorSection> createState() =>
      _SensorSectionState();
}

class _SensorSectionState extends State<SensorSection> {
  StreamSubscription<AccelerometerEvent>? subscription;

  double x = 0;
  double y = 0;
  double z = 0;

  String status = 'Starting sensor...';

  @override
  void initState() {
    super.initState();
    startSensor();
  }

  void startSensor() {
    subscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!mounted) return;

        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
          status = 'Accelerometer active';
        });
      },
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          status = 'Accelerometer unavailable on this device';
        });
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Widget sensorValue(String axis, double value) {
    return ListTile(
      leading: const Icon(Icons.sensors),
      title: Text('Axis $axis'),
      trailing: Text(
        '${value.toStringAsFixed(2)} m/s²',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accelerometer Sensor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(status),
            const Divider(),
            sensorValue('X', x),
            sensorValue('Y', y),
            sensorValue('Z', z),
            const Text(
              'Move or tilt your device to observe changing readings.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}