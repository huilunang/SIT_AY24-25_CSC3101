import 'package:bloobin_app/features/home/domain/chart_data.dart';

class Home {
  final String point;
  final String reward;
  final List<ChartData> chartData;

  Home(this.point, this.reward, this.chartData);
}
