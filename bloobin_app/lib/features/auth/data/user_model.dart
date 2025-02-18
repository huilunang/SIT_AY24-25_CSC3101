class UserSignInModel {
  final String jwtToken;
  final int userId;
  final int points;

  UserSignInModel(
      {required this.jwtToken, required this.userId, required this.points});

  factory UserSignInModel.fromJson(Map<String, dynamic> json) {
    return UserSignInModel(
      jwtToken: json['token'],
      userId: json['user']['id'],
      points: json['user']['points'],
    );
  }
}
