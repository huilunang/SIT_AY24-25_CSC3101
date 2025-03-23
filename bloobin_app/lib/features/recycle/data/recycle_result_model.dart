class RecycleResultModel {
  String material;
  String pointsMessage;
  String? remark;

  RecycleResultModel(
      {required this.material, required this.pointsMessage, this.remark});

  factory RecycleResultModel.fromJson(Map<String, dynamic> json) {
    return RecycleResultModel(
      material: json['material'] as String,
      pointsMessage: json['points_message'] as String,
      remark: json['remark'] as String?,
    );
  }
}
