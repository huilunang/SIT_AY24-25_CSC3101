import 'package:bloobin_app/features/auth/presentation/pages/signin_page.dart';
import 'package:bloobin_app/navigation/blocs/navigation_bloc.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final MaterialTheme materialTheme = MaterialTheme(
      ThemeData.light().textTheme,
    );

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => NavigationBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bloobin App',
        theme: materialTheme.light(),
        home: const SignInPage(),
      ),
    );
  }
}
