import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/reward_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final HomeRepository _homeRepository;

  RewardBloc(this._homeRepository) : super(RewardInitial()) {
    on<RewardLoaded>((event, emit) async {
      try {
        emit(RewardLoadInProgress());
        final rewardList = await _homeRepository.fetchRewardDetails();

        if (rewardList.isEmpty) {
          emit(RewardEmpty());
        } else {
          emit(RewardLoadSuccess(rewardList));
        }
      } catch (e) {
        emit(RewardError('Failed to retrieve rewards: $e'));
      }
    });

    on<RewardClaimed>((event, emit) async {
      try {
        await _homeRepository.claimRewardVoucher(event.reward);
        emit(RewardClaimSuccess(
            'Successfully claim to use ${event.reward.name} (${event.reward.serialNo})'));
        final updatedRewardList = await _homeRepository.fetchRewardDetails();
        emit(RewardLoadSuccess(updatedRewardList));
        event.homeBloc.add(HomeLoaded());
      } catch (e) {
        emit(RewardClaimError('Failed to claim reward voucher: $e'));
      }
    });
  }
}
