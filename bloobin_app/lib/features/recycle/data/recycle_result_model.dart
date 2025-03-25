class RecycleResultModel {
  String material;
  String pointsMessage;
  String imageBase64;
  String? remark;

  RecycleResultModel(
      {required this.material,
      required this.pointsMessage,
      required this.imageBase64,
      this.remark});

  factory RecycleResultModel.fromJson(Map<String, dynamic> json) {
    return RecycleResultModel(
      material: json['material'] as String,
      pointsMessage: json['points_message'] as String,
      imageBase64: json['image_base64'] as String,
      remark: json['remark'] as String?,
    );
  }
}
