import 'package:flutter/material.dart';

class DeforestedAreasScreen extends StatelessWidget {
  const DeforestedAreasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deforested Areas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forest,
              size: 100,
              color: Colors.brown.shade700,
            ),
            const SizedBox(height: 20),
            const Text(
              'Deforested Areas Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Monitor and report deforested areas to help conservation efforts.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement deforested areas mapping functionality
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('View Deforested Areas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 