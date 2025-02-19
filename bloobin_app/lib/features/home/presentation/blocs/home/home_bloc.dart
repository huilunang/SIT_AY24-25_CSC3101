import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(HomeInitial()) {
    on<HomeLoaded>((event, emit) async {
      try {
        emit(HomeLoadInProgress());
        final home = await _homeRepository.fetchHomeDetails(
            frequency: event.newFrequency);
        emit(HomeLoadSuccess(event.newFrequency, home));
      } catch (e) {
        emit(HomeError('Failed to retrieve home details: $e'));
      }
    });
  }
}
