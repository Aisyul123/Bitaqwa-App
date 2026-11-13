import 'package:flutter/material.dart';

import 'package:bitaqwa_app/presentation/screen/dashboard.dart';
import 'package:bitaqwa_app/presentation/screen/doa_screen.dart';
import 'package:bitaqwa_app/presentation/screen/zakat_screen.dart';
import 'package:bitaqwa_app/presentation/screen/jadwal_sholat_screen.dart';
import 'package:bitaqwa_app/presentation/screen/video_kajian_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitaqwa',

      // HALAMAN PERTAMA
      initialRoute: '/',

      // DAFTAR ROUTE
      routes: {
        '/': (context) => const DashboardScreen(),
        '/doa': (context) => const DoaScreen(),
        '/zakat': (context) => const ZakatScreen(),
        '/jadwal': (context) => const JadwalSholatScreen(),
        '/video': (context) => const VideoKajianScreen(),
      },
    );
  }
}