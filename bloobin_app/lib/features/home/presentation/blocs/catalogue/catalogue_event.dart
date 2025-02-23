import 'package:bloobin_app/features/home/domain/catalogue.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_bloc.dart';

sealed class CatalogueEvent {}

class CatalogueLoaded extends CatalogueEvent {
  CatalogueLoaded();
}

class CatalogueRedeemed extends CatalogueEvent {
  final HomeBloc homeBloc;
  final PointsBloc pointsBloc;
  final String points;
  final Catalogue selectedCatalogue;

  CatalogueRedeemed(
      this.homeBloc, this.pointsBloc, this.points, this.selectedCatalogue);
}
