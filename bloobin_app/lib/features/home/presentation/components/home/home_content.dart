import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/features/auth/presentation/pages/signin_page.dart';
import 'package:bloobin_app/features/home/presentation/components/home/analytics_widget.dart';
import 'package:bloobin_app/features/home/presentation/components/home/header_widget.dart';
import 'package:bloobin_app/features/home/presentation/components/home/reward_widget.dart';
import 'package:bloobin_app/navigation/blocs/navigation_event.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  void _handleSignOut() async {
    await AuthHelper.removeUserAuthFromLocalStorage();

    if (mounted) {
      context.navigationBloc.add(Navigated(0));

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => _handleSignOut(), icon: const Icon(Icons.logout))
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(height: 16),
            RewardsWidget(),
            SizedBox(height: 24),
            AnalyticsWidget(),
          ],
        ),
      ),
    );
  }
}
