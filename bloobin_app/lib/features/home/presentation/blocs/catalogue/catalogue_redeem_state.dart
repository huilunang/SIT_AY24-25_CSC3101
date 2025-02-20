sealed class CatalogueRedeemState {}

final class CatalogueRedeemInitial extends CatalogueRedeemState {}

final class CatalogueRedeemSuccess extends CatalogueRedeemState {
  final String message;

  CatalogueRedeemSuccess(this.message);
}

final class CatalogueRedeemError extends CatalogueRedeemState {
  final String errorMessage;

  CatalogueRedeemError(this.errorMessage);
}
