import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_state.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogueBloc extends Bloc<CatalogueEvent, CatalogueState> {
  final HomeRepository _homeRepository;

  CatalogueBloc(this._homeRepository) : super(CatalogueInitial()) {
    on<CatalogueLoaded>((event, emit) async {
      try {
        emit(CatalogueLoadInProgress());
        final catalogue = await _homeRepository.fetchCatalogueDetails();

        if (catalogue.isEmpty) {
          emit(CatalogueEmpty());
        } else {
          emit(CatalogueLoadSuccess(catalogue));
        }
      } catch (e) {
        emit(CatalogueError('Failed to retrieve catalogue: $e'));
      }
    });

    on<CatalogueRedeemed>((event, emit) async {
      try {
        int pointsLeft = await _homeRepository.redeemCatalogueVoucher(
            event.points, event.selectedCatalogue);
        emit(CatalogueRedeemSuccess(
            'Successfully redeemed! You have $pointsLeft pts left'));
        event.pointsBloc.add(PointsLoaded());
        event.homeBloc.add(HomeLoaded());
      } catch (e) {
        emit(CatalogueRedeemError(
            'Failed to redeem catalogue voucher using points: $e'));
      }
    });
  }
}
