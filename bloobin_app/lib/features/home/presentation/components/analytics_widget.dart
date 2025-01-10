import 'package:bloobin_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home_state.dart';
import 'package:bloobin_app/features/home/presentation/components/stacked_bar_chart_widget.dart';
import 'package:bloobin_app/features/home/presentation/components/chart_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
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
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadSuccess) {
                    return StackedBarChartWidget(
                      frequency: state.frequency,
                      chartData: state.home.chartData,
                    );
                  } else if (state is HomeError) {
                    return Center(child: Text(state.errorMessage));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
