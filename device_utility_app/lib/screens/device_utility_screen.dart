import 'package:flutter/material.dart';

import '../widgets/image_picker_section.dart';
import '../widgets/sensor_section.dart';
import '../widgets/location_section.dart';

class DeviceUtilityScreen extends StatelessWidget {
  const DeviceUtilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Utility App'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ImagePickerSection(),
            SizedBox(height: 20),
            SensorSection(),
            SizedBox(height: 20),
            LocationSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}