import 'package:bloobin_app/features/home/presentation/components/points/points_widget.dart';
import 'package:flutter/material.dart';

class PointsPage extends StatelessWidget {
  final String points;

  const PointsPage({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PointsWidget(points: points),
            ],
          )),
    );
  }
}
