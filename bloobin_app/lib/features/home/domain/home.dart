import 'package:bloobin_app/features/home/domain/chart_data.dart';

class Home {
  final String points;
  final String rewards;

  final List<String> types;
  final List<ChartData> chartData;

  Home(this.points, this.rewards, this.types, this.chartData);
}
