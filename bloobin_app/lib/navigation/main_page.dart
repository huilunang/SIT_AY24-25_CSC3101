import 'package:bloobin_app/features/auth/presentation/pages/profile_page.dart';
import 'package:bloobin_app/features/home/presentation/pages/home_page.dart';
import 'package:bloobin_app/features/recycle/presentation/pages/recycle_page.dart';
import 'package:bloobin_app/navigation/blocs/navigation_bloc.dart';
import 'package:bloobin_app/navigation/blocs/navigation_event.dart';
import 'package:bloobin_app/navigation/blocs/navigation_state.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const RecyclePage(),
      const ProfilePage()
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        final selectedIndex =
            state is NavigationLoaded ? state.selectedIndex : 0;

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                context.navigationBloc.add(Navigated(index)),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.camera_alt_outlined), label: 'Recycle'),
              NavigationDestination(
                  icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
            ],
          ),
          body: pages[selectedIndex],
        );
      },
    );
  }
}
