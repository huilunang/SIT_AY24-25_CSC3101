import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final HomeRepository _homeRepository;

  PointsBloc(this._homeRepository) : super(PointsInitial()) {
    on<PointsLoaded>((event, emit) async {
      try {
        emit(PointsLoadInProgress());
        final points = await _homeRepository.fetchPointDetails();
        emit(PointsLoadSuccess(points));
      } catch (e) {
        emit(PointsError('Failed to retrieve points: $e'));
      }
    });
  }
}