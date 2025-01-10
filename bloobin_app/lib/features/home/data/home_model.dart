import 'package:bloobin_app/features/home/domain/chart_data.dart';

class HomeModel {
  final String point;
  final String reward;
  final List<ChartData> chartData;

  HomeModel(
      {required this.point, required this.reward, required this.chartData});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      point: json['point'] as String,
      reward: json['reward'] as String,
      chartData: json['chartData'],
    );
  }

  // Method to convert TaskModel to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'point': point,
  //     'reward': reward,
  //     'chartData': chartData,
  //   };
  // }
}
