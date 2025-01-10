sealed class NavigationState {}

final class NavigationLoadInProgress extends NavigationState {
  final int selectedIndex;

  NavigationLoadInProgress(this.selectedIndex);
}

final class NavigationError extends NavigationState {
  final String errorMessage;

  NavigationError(this.errorMessage);
}
