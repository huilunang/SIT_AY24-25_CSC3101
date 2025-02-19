import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_state.dart';
import 'package:bloobin_app/features/home/presentation/components/home/stacked_bar_chart_widget.dart';
import 'package:bloobin_app/features/home/presentation/components/home/chart_dropdown_widget.dart';
import 'package:bloobin_app/features/home/presentation/components/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SectionWidget(
        sectionHeader: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Analytics',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            ChartDropdownWidget(),
          ],
        ),
        sectionChild: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadSuccess) {
              return StackedBarChartWidget(
                frequency: state.frequency,
                types: state.home.types,
                chartData: state.home.chartData,
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.errorMessage));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
