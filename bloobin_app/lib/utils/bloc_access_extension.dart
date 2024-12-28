import 'package:bloobin_app/navigation/blocs/navigation_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocAcess on BuildContext {
  NavigationBloc get navigationBloc => read<NavigationBloc>();
}