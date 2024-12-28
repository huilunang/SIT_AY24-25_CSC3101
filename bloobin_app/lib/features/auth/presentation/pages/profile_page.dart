import 'package:bloobin_app/features/auth/presentation/pages/signin_page.dart';
import 'package:bloobin_app/navigation/blocs/navigation_event.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      child: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );

          context.navigationBloc.add(Navigated(0));
        },
        child: const Text('Logout'),
      )),
    );
  }
}
