import 'package:bloobin_app/features/home/domain/catalogue.dart';

sealed class CatalogueState {}

final class CatalogueInitial extends CatalogueState {}

final class CatalogueLoadInProgress extends CatalogueState {}

final class CatalogueLoadSuccess extends CatalogueState {
  final List<Catalogue> catalogueList;

  CatalogueLoadSuccess(this.catalogueList);
}

final class CatalogueError extends CatalogueState {
  final String errorMessage;

  CatalogueError(this.errorMessage);
}
