import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_redeem_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_redeem_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogueRedeemBloc
    extends Bloc<CatalogueRedeemEvent, CatalogueRedeemState> {
  final HomeRepository _homeRepository;

  CatalogueRedeemBloc(this._homeRepository) : super(CatalogueRedeemInitial()) {
    on<CatalogueRedeemed>((event, emit) async {
      try {
        int pointsLeft = await _homeRepository.redeemCatalogueVoucher(
            event.points, event.selectedCatalogue);
        emit(CatalogueRedeemSuccess(
            'Successfully redeemed! You have $pointsLeft pts left'));
      } catch (e) {
        emit(CatalogueRedeemError(
            'Failed to redeem catalogue voucher using points: $e'));
      }
    });

    on<CatalogueReedemErrorDialog>((event, emit) {
      emit(CatalogueRedeemInitial());
    });
  }
}
