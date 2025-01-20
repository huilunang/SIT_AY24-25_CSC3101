class RecycleResultModel {
  String material;
  int pointsEarned;

  RecycleResultModel({required this.material, required this.pointsEarned});

  factory RecycleResultModel.fromJson(Map<String, dynamic> json) {
    return RecycleResultModel(
      material: json['material'] as String,
      pointsEarned: json['points'] as int,
    );
  }
}
