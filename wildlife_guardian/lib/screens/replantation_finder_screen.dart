import 'package:flutter/material.dart';

class ReplantationFinderScreen extends StatelessWidget {
  const ReplantationFinderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replantation Finder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.nature,
              size: 100,
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 20),
            const Text(
              'Find Replantation Areas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Discover areas where replantation efforts are ongoing or needed.',
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
                // TODO: Implement replantation finder functionality
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('Explore Replantation Sites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 