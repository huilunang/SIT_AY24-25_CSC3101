import 'package:bloobin_app/features/auth/data/auth_repository.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignedIn>((event, emit) async {
      try {
        emit(AuthLoadInProgress());
        await _authRepository.signIn(event.email, event.password);
        emit(AuthLoadSuccess());
      } catch (e) {
        emit(AuthError("Failed to sign in: ${e.toString()}"));
      }
    });

    on<AuthSignedUp>((event, emit) async {
      try {
        emit(AuthLoadInProgress());
        await _authRepository.signUp(
            event.email, event.password, event.confirmPassword);
        emit(AuthLoadSuccess());
      } catch (e) {
        emit(AuthSignUpError("Failed to sign up: ${e.toString()}"));
      }
    });
  }
}
