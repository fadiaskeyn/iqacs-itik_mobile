import 'package:flutter/material.dart';
import 'package:inovokasi_rebuild/screens/login_screen.dart';
import 'package:inovokasi_rebuild/screens/dashboard.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      title: 'IQACS Duck',
      theme: ThemeData(
        primarySwatch: Colors.brown, // Sesuaikan dengan tema Anda
      ),
      initialRoute: '/dashboard', // Route awal saat aplikasi dibuka
      routes: {
        '/login': (context) => LoginScreen(), // Halaman Login
        '/dashboard': (context) => Dashboard(), // Halaman Dashboard
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
