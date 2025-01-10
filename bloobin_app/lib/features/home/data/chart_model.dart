class ChartModel {
  final String date;
  final String type;
  final int count;

  ChartModel(this.date, this.type, this.count);

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      json['date'],
      json['type'],
      json['type_count'],
    );
  }
}
