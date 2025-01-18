import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_state.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Vouchers',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Click to claim the vouchers',
              style: TextStyle(color: colorScheme.secondary),
            ),
            const SizedBox(height: 20),
            BlocBuilder<RewardsBloc, RewardsState>(
              builder: (context, state) {
                if (state is RewardsLoadSuccess) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.rewardsList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10), // Space between items
                      itemBuilder: (context, index) {
                        final voucher = state.rewardsList[index];
                        final dateFormatter = DateFormat('yyyy-MM-dd');

                        return GestureDetector(
                          onTap: () {
                            print('Clicked on ${voucher.name}');
                            // Add navigation or dialog here if needed
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: index.isEven
                                ? colorScheme.sectionContainerLightScheme
                                : colorScheme.surface, // Alternate colors
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    voucher.name,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    dateFormatter.format(
                                        DateTime.parse(voucher.validDate)),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is RewardsLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RewardsError) {
                  return Center(child: Text(state.errorMessage));
                } else {
                  return const Center(child: Text('No rewards available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
