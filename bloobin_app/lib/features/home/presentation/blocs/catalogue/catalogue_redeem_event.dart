import 'package:bloobin_app/features/home/domain/catalogue.dart';

sealed class CatalogueRedeemEvent {}

class CatalogueRedeemed extends CatalogueRedeemEvent {
  final String points;
  final Catalogue selectedCatalogue;

  CatalogueRedeemed(this.points, this.selectedCatalogue);
}

class CatalogueReedemErrorDialog extends CatalogueRedeemEvent {}
