import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogueBloc extends Bloc<CatalogueEvent, CatalogueState> {
  final HomeRepository _homeRepository;

  CatalogueBloc(this._homeRepository) : super(CatalogueInitial()) {
    on<CatalogueLoaded>((event, emit) async {
      try {
        emit(CatalogueLoadInProgress());
        final catalogue = await _homeRepository.fetchCatalogueDetails();
        emit(CatalogueLoadSuccess(catalogue));
      } catch (e) {
        emit(CatalogueError('Failed to retrieve catalogue: $e'));
      }
    });
  }
}
