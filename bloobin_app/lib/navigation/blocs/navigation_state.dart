sealed class NavigationState {}

final class NavigationLoaded extends NavigationState {
  final int selectedIndex;

  NavigationLoaded(this.selectedIndex);
}

final class NavigationError extends NavigationState {
  final String errorMessage;

  NavigationError(this.errorMessage);
}