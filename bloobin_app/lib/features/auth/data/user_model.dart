class UserSignInModel {
  final String jwtToken;
  final int points;

  UserSignInModel({required this.jwtToken, required this.points});

  factory UserSignInModel.fromJson(Map<String, dynamic> json) {
    return UserSignInModel(
      points: json['points'],
      jwtToken: json['token'],
    );
  }
}
