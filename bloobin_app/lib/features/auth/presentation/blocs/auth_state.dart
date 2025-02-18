sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadInProgress extends AuthState {}

final class AuthLoadSuccess extends AuthState {}

final class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}

// fix due to clash of bloclistener state with snackbars
final class AuthSignUpError extends AuthState {
  final String errorMessage;

  AuthSignUpError(this.errorMessage);
}