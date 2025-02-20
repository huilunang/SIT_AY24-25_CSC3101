import 'package:bloobin_app/features/auth/data/auth_repository.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:bloobin_app/features/auth/presentation/pages/signin_page.dart';
import 'package:bloobin_app/features/home/data/home_repository.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/catalogue/catalogue_redeem_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/points/points_bloc.dart';
import 'package:bloobin_app/features/home/presentation/blocs/rewards/rewards_bloc.dart';
import 'package:bloobin_app/navigation/blocs/navigation_bloc.dart';
import 'package:bloobin_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialTheme materialTheme = MaterialTheme(
      ThemeData.light().textTheme,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => HomeRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationBloc()),
          BlocProvider(
              create: (context) => AuthBloc(
                    RepositoryProvider.of<AuthRepository>(context),
                  )),
          BlocProvider(
              create: (context) => HomeBloc(
                    RepositoryProvider.of<HomeRepository>(context),
                  )),
          BlocProvider(
              create: (context) => PointsBloc(
                    RepositoryProvider.of<HomeRepository>(context),
                  )),
          BlocProvider(
              create: (context) => RewardsBloc(
                    RepositoryProvider.of<HomeRepository>(context),
                  )),
          BlocProvider(
              create: (context) => CatalogueBloc(
                    RepositoryProvider.of<HomeRepository>(context),
                  )),
          BlocProvider(
              create: (context) => CatalogueRedeemBloc(
                    RepositoryProvider.of<HomeRepository>(context),
                  )),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bloobin App',
          theme: materialTheme.light(),
          home: const SignInPage(),
        ),
      ),
    );
  }
}
