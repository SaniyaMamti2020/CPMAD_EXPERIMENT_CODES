import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          const CircleAvatar(
            radius: 55,

            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Student',

            style: TextStyle(
              fontSize: 25,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Flutter Developer',
          ),

          const SizedBox(height: 25),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.email),

                  title:
                      const Text('Email'),

                  subtitle:
                      const Text(
                    'student@example.com',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.phone),

                  title:
                      const Text('Phone'),

                  subtitle:
                      const Text(
                    '+91 98765 43210',
                  ),
                ),

                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                  ),

                  title:
                      const Text('Location'),

                  subtitle:
                      const Text(
                    'Gujarat, India',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}