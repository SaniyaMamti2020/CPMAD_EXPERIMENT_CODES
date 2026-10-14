import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/device_location.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() =>
      _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  DeviceLocation? location;
  String message = 'Location not requested';
  bool loading = false;

  Future<void> getCurrentLocation() async {
    setState(() {
      loading = true;
      message = 'Getting current location...';
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          message = 'Please enable GPS/location services.';
          loading = false;
        });
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          message = 'Location permission denied.';
          loading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          message =
              'Permission permanently denied. Enable it in app settings.';
          loading = false;
        });
        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      setState(() {
        location = DeviceLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        message = 'Location obtained successfully';
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = 'Unable to get location. Check GPS and try again.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GPS Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(message),

            if (location != null) ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on),
                title: const Text('Latitude'),
                subtitle: Text(
                  location!.latitude.toStringAsFixed(6),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.explore),
                title: const Text('Longitude'),
                subtitle: Text(
                  location!.longitude.toStringAsFixed(6),
                ),
              ),
            ],

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    loading ? null : getCurrentLocation,
                icon: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  loading
                      ? 'Getting Location...'
                      : 'Get Current Location',
                ),
              ),
            ),

            if (message.contains('permanently denied'))
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                },
                child: const Text('Open App Settings'),
              ),
          ],
        ),
      ),
    );
  }
}