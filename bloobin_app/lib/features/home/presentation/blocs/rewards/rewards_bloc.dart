import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final HomeRepository _homeRepository;

  RewardsBloc(this._homeRepository) : super(RewardsInitial()) {
    on<RewardsLoaded>((event, emit) async {
      try {
        emit(RewardsLoadInProgress());
        final rewardsList = await _homeRepository.fetchRewardDetails();
        emit(RewardsLoadSuccess(rewardsList));
      } catch (e) {
        emit(RewardsError('Failed to retrieve rewards: $e'));
      }
    });
  }
}
