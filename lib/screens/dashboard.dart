import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovokasi_rebuild/Theme.dart';
import 'package:inovokasi_rebuild/widgets/gas_card.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../service/api_service.dart';
import '../widgets/chart.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isOn = false;
  int? selectedAlat;
  final List<int> listAlat = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    if (selectedAlat == null && listAlat.isNotEmpty) {
      selectedAlat = 1; // Atur nilai awal
    }
  }

  void onToggle(bool value) {
    setState(() {
      _isOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsCubit(ApiService()),
      child: Scaffold(
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
                            side:
                                const BorderSide(color: Colors.brown, width: 1),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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

                // Slice kedua (grafik)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 350,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: BarChartSample(
                          title: "Data Bar Chart",
                          leftBarColor: Colors.blue,
                          rightBarColor: Colors.red,
                          avgColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
        // Shadow (optional, bisa kamu tambahkan untuk efek bayangan)
        Positioned(
          top: 5,
          left: 20,
          child: Icon(Icons.notifications, color: Colors.white),
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
              "Pilih alat",
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

class LampuCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;

  const LampuCard({required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            isOn ? "assets/lamp_on.png" : "assets/lamp_off.png",
            width: 120.0,
            height: 120.0,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Status Lampu",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isOn ? "Hidup" : "Mati",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: Switch(
                        value: isOn,
                        onChanged: onToggle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
      //
    );
  }
}

class DashboardGrid extends StatelessWidget {
  final double temperature;
  final double humidity;
  final int ammonia;
  final bool isLampOn;

  const DashboardGrid({
    Key? key,
    required this.ammonia,
    required this.temperature,
    required this.humidity,
    required this.isLampOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Amonia

        Container(
          height: 150, // Pastikan tinggi ditentukan
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

        // Cards Suhu & Kelembapan
        SizedBox(
          height: 150, // Tinggi harus tetap
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

        // Grafik Data
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 100,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: BarChartSample(
                  title: "Data Bar Chart",
                  leftBarColor: Colors.blue,
                  rightBarColor: Colors.red,
                  avgColor: Colors.green,
                ),
              ),
            ),
          ),
        ),
      ],
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
      // Pastikan tinggi minimum diterapkan
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
