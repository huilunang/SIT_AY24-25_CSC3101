import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloobin_app/common_widgets/custom_snack_bar.dart';
import 'package:bloobin_app/features/recycle/data/recycle_result_model.dart';
import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final File imageFile;
  final RecycleResultModel recycleResult;

  const ConfirmationPage(
      {super.key, required this.imageFile, required this.recycleResult});

  @override
  Widget build(BuildContext context) {
    if (recycleResult.remark != null && recycleResult.remark!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.show(context, recycleResult.remark!, type: 'error'));
      });
    }

    Uint8List imageBytes = base64Decode(recycleResult.imageBase64);

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
                  // image: FileImage(imageFile),
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Text(
              "Material: ${recycleResult.material}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              recycleResult.pointsMessage,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                minimumSize: const Size(150, 50),
              ),
              onPressed: () async {
                if (await imageFile.exists()) {
                  await imageFile.delete();
                  print("Image deleted: ${imageFile.path}");
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
