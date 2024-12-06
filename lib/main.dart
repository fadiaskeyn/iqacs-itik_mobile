import 'package:flutter/material.dart';
import 'package:inovokasi_rebuild/screens/login_screen.dart';
import 'package:inovokasi_rebuild/screens/dashboard.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovokasi_rebuild/cubit/chart_cubit.dart';
import '../cubit/stats_cubit.dart';
import '../service/api_service.dart';
import '../service/chart_api_service.dart';
import 'screens/tap_water.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StatsCubit(ApiService())),
        BlocProvider(create: (context) => ChartCubit(ChartService())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IQACS Duck',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => ProfilePage(),
        '/tapwater': (context) => TapWater(),
      },
    );
  }
}
