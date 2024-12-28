sealed class NavigationEvent {}

class Navigated extends NavigationEvent {
  final int index;

  Navigated(this.index);
}
