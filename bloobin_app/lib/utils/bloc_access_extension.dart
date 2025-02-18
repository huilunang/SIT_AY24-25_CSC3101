import 'package:bloobin_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_bloc.dart';
import 'package:bloobin_app/navigation/blocs/navigation_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocAcess on BuildContext {
  NavigationBloc get navigationBloc => read<NavigationBloc>();

  AuthBloc get authBloc => read<AuthBloc>();

  HomeBloc get homeBloc => read<HomeBloc>();

  PointsBloc get pointsBloc => read<PointsBloc>();

  RewardsBloc get rewardsBloc => read<RewardsBloc>();

  CatalogueBloc get catalogueBloc => read<CatalogueBloc>();
}
