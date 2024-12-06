import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovokasi_rebuild/Theme.dart';
import 'package:inovokasi_rebuild/cubit/chart_cubit.dart';
import 'package:inovokasi_rebuild/widgets/gas_card.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../service/api_service.dart';
import '../widgets/chart.dart';
import '../widgets/lamp_card.dart';
import '../service/chart_api_service.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isOn = false;
  int? selectedAlat;
  final List<int> listAlat = [1, 2, 3, 4, 5];
  Timer? _timer; // Timer untuk refresh otomatis

  void onToggle(bool value) {
    setState(() {
      _isOn = value;
    });
  }

  @override
  void initState() {
    super.initState();

    // Fetch data pertama kali
    Future.microtask(() {
      context.read<ChartCubit>().fetchChartStats();
    });

    // Setup timer untuk refresh otomatis setiap 5 detik
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Panggil metode untuk fetch data
      context.read<ChartCubit>().fetchChartStats();
    });
  }

  @override
  void dispose() {
    // Hentikan timer saat widget dihancurkan
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        toolbarHeight: 1,
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          double temperature = 0.0;
          double humidity = 0.0;
          int ammonia = 0;

          if (state is StatsLoaded) {
            temperature = state.stats.temperature;
            humidity = state.stats.humidity;
            ammonia = state.stats.ammonia;
          } else if (state is StatsError) {
            return Center(child: Text(state.message));
          } else if (state is StatsLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return PageView(
            children: [
              // Slice pertama
              SingleChildScrollView(
                child: Column(
                  children: [
                    DashboardHeader(),
                    DashboardBanner(
                      listAlat: listAlat,
                      selectedAlat: selectedAlat,
                      onChanged: (value) {
                        setState(() {
                          selectedAlat = value;
                          if (value != null) {
                            context.read<StatsCubit>().fetchStats(value);
                          }
                        });
                      },
                    ),
                    LampuCard(isOn: _isOn, onToggle: onToggle),

                    // Card Amonia
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.brown, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/amonia.png",
                                width: 65.0,
                                height: 65.0,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                'Gas Amonia: $ammonia ppm',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card Suhu & Kelembapan
                    SizedBox(
                      height: 500,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          GasCard(
                            title: 'Kelembapan',
                            kode: '%',
                            value: humidity,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          GasCard(
                            title: 'Suhu',
                            kode: '°C',
                            value: temperature,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Grafik
              BlocBuilder<ChartCubit, ChartState>(
                builder: (context, chartState) {
                  if (chartState.error != null) {
                    return Center(child: Text('Error: ${chartState.error}'));
                  } else if (chartState.stats != null) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        child: BarChartSample(
                          title: "Data Bar Chart",
                          leftBarColor: Colors.blue,
                          rightBarColor: Colors.red,
                          avgColor: Colors.green,
                          data: chartState.stats!, // Data diteruskan ke grafik
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text("No data available."));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          color: darkBrown,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/profile_image.png'),
                radius: 26,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang',
                    style: whitekTextStyle.copyWith(fontWeight: light),
                  ),
                  Text(
                    'Admin',
                    style: whitekTextStyle.copyWith(fontWeight: regular),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.menu),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardBanner extends StatelessWidget {
  final List<int> listAlat;
  final int? selectedAlat;
  final ValueChanged<int?>
      onChanged; // Callback untuk menangani perubahan dropdown

  const DashboardBanner({
    required this.listAlat,
    this.selectedAlat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkBrown,
        image: DecorationImage(
          image: AssetImage('assets/bgss.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Kualitas udara',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          DropdownButton<int>(
            hint: Text(
              "Pilih Alat",
              style: TextStyle(color: Colors.white),
            ),
            value: selectedAlat,
            items: listAlat.map((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class GasAmoniaCard extends StatelessWidget {
  final int ammonia;

  const GasAmoniaCard({required this.ammonia});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _HeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.yellow,
      height: maxExtent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.child != child;
  }
}
