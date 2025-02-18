sealed class AuthEvent {}

class AuthSignedIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignedIn({required this.email, required this.password});
}

class AuthSignedUp extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  AuthSignedUp(
      {required this.email,
      required this.password,
      required this.confirmPassword});
}
