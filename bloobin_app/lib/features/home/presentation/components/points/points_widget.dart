import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_event.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_state.dart';
import 'package:bloobin_app/features/home/presentation/components/section_widget.dart';
import 'package:bloobin_app/features/home/presentation/pages/catalogue_page.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PointsWidget extends StatelessWidget {
  const PointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: BlocBuilder<PointsBloc, PointsState>(
                builder: (context, state) {
                  if (state is PointsLoadSuccess) {
                    final points = state.points.points;

                    return Column(
                      children: [
                        Text(
                          "$points pts",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.catalogueBloc.add(CatalogueLoaded());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CataloguePage(
                                  points: points.toString(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Redeem Points'),
                        ),
                      ],
                    );
                  } else if (state is PointsLoadInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PointsError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const Center(child: Text('No points available.'));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SectionWidget(
              sectionHeader: const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              sectionChild: BlocBuilder<PointsBloc, PointsState>(
                builder: (context, state) {
                  if (state is PointsLoadSuccess) {
                    final recordData = state.points.recordData;
                    final dateFormatter = DateFormat('yyyy-MM-dd');

                    return ListView.separated(
                      itemCount: recordData.keys.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final rawDate = recordData.keys.elementAt(index);
                        final formattedDate =
                            dateFormatter.format(DateTime.parse(rawDate));
                        final transactions = recordData[rawDate]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...transactions.map(
                              (item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(item),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    );
                  } else if (state is PointsLoadInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PointsError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const Center(
                        child: Text('No transactions available.'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
