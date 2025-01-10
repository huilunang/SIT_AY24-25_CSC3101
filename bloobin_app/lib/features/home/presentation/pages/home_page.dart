import 'package:bloobin_app/features/home/presentation/blocs/home_event.dart';
import 'package:bloobin_app/features/home/presentation/components/home_content.dart';
import 'package:bloobin_app/features/home/presentation/pages/points_page.dart';
import 'package:bloobin_app/features/home/presentation/pages/rewards_page.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    if (mounted) {
      context.homeBloc.add(HomeLoaded());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/reward':
            return MaterialPageRoute(builder: (_) => const RewardsPage());
          case '/points':
            return MaterialPageRoute(builder: (_) => const PointsPage());
          default:
            return MaterialPageRoute(builder: (_) => const HomeContent());
        }
      },
    );
  }

  void resetNavigator() {
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    resetNavigator(); // Ensure cleanup
    super.dispose();
  }
}
