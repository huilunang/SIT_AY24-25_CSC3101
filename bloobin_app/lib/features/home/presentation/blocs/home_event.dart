sealed class HomeEvent {}

class HomeLoaded extends HomeEvent {
  final String newFrequency;

  HomeLoaded({this.newFrequency = 'Daily'});
}
