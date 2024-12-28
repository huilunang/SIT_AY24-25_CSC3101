import 'package:bloobin_app/navigation/blocs/navigation_event.dart';
import 'package:bloobin_app/navigation/blocs/navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationLoaded(0)) {
    on<Navigated>((event, emit) {
      try {
        emit(NavigationLoaded(event.index));
      } catch (e) {
        emit(NavigationError('Failed to navigate: $e'));
      }
    });
  }
}