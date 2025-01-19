import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  final File imageFile;

  const ConfirmationPage({super.key, required this.imageFile});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late Future<Map<String, dynamic>> _analysisFuture;

  @override
  void initState() {
    super.initState();
    _analysisFuture = _analyzeImage();
  }

  Future<Map<String, dynamic>> _analyzeImage() async {
    // Simulate server response
    await Future.delayed(const Duration(seconds: 2));
    return {
      "material": "Plastic Bottle",
      "points": 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(widget.imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 35),
            FutureBuilder<Map<String, dynamic>>(
              future: _analysisFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return const Text('Error analyzing image');
                } else if (snapshot.hasData) {
                  final material = snapshot.data!['material'];
                  final points = snapshot.data!['points'];

                  return Column(
                    children: [
                      Text(
                        "Material: $material",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Points Earned: $points",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                minimumSize: const Size(150, 50),
              ),
              onPressed: () async {
                if (await widget.imageFile.exists()) {
                  await widget.imageFile.delete();
                  print("Image deleted: ${widget.imageFile.path}");
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
