import 'package:bloobin_app/features/home/domain/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedBarChartWidget extends StatelessWidget {
  final String frequency;
  final List<String> types;
  final List<dynamic> chartData;

  late final TooltipBehavior _tooltipBehavior;

  StackedBarChartWidget({
    super.key,
    required this.frequency,
    required this.types,
    required this.chartData,
  }) {
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  List<ChartData> _processData() {
    final Map<String, Map<String, int>> groupedData = {};

    for (var entry in chartData) {
      // Parse the date and format based on frequency
      final dateKey = frequency.toLowerCase() == 'daily'
          ? DateFormat('dd/MM').format(DateTime.parse(entry.date))
          : DateFormat('MM/yy').format(DateTime.parse(entry.date));

      // Initialize entry for dateKey if not already present
      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = {for (var type in types) type: 0};
      }

      groupedData[dateKey]![entry.type] = entry.count;
    }

    // Flatten the grouped data into a list of ChartData
    return groupedData.entries
        .expand((entry) => entry.value.entries.map(
              (typeEntry) => ChartData(
                entry.key,
                typeEntry.key,
                typeEntry.value,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No data available for the selected period.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final parsedData = _processData();

    // Define types and corresponding colors for the chart series
    // final colors = {
    //   'Plastic': Colors.blue[200],
    //   'Cardboard': Colors.green[600],
    //   'Metal': Colors.red[300],
    // };

    return SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      legend: const Legend(isVisible: true),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(),
      series: types.map((type) {
        final filteredData =
            parsedData.where((item) => item.type == type).toList();
        return StackedColumnSeries<ChartData, String>(
          dataSource: filteredData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.count,
          name: type,
          // color: colors[type],
        );
      }).toList(),
    );
  }
}
