import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // =========================
  // BACKGROUND SESUAI WAKTU
  // =========================
  String getBackground() {
    int jam = DateTime.now().hour;

    if (jam >= 6 && jam <= 12) {
      return 'assets/images/background_pagi.png';
    } else if (jam >= 13 && jam <= 18) {
      return 'assets/images/background_siang.png';
    } else {
      return 'assets/images/background_malam.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // BACKGROUND ATAS
              // =========================
              SizedBox(
                width: double.infinity,
                height: 230,

                child: Stack(
                  children: [

                    // BACKGROUND SESUAI JAM
                    SizedBox(
                      width: double.infinity,
                      height: 230,

                      child: Image.asset(
                        getBackground(),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // NAMA BITAQWA
                    const Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,

                      child: Text(
                        'Bitaqwa',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // GREETING
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Text(
                    'Assalamualaikum Fulan',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // MENU
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9A6C),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,

                    children: [

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/doa');
                        },

                        child: menuItem(
                          'assets/images/doa.png',
                          'Doa-Doa',
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/zakat');
                        },

                        child: menuItem(
                          'assets/images/zakat.png',
                          'Zakat',
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/jadwal');
                        },

                        child: menuItem(
                          'assets/images/jadwal sholat.png',
                          'Jadwal Sholat',
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/video');
                        },

                        child: menuItem(
                          'assets/images/video kajian.png',
                          'Video Kajian',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // INSPIRASI
              // =========================
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Text(
                  'Inspirasi',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // FOTO INSPIRASI 1
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                
                child: Container(
                  width: 1000,
                  height: 600,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Image.asset(
                    'assets/images/Kata Kasar.png',
                    fit: BoxFit.cover,

                  ),
                ),
              ),

              const SizedBox(height: 12),

              // FOTO INSPIRASI 2
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Container(
                  width: 1000,
                  height: 600,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Image.asset(
                    'assets/images/Kata Kasar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // MENU ITEM
  // =========================
  Widget menuItem(
    String gambar,
    String judul,
  ) {
    return Column(
      children: [

        Container(
          width: 55,
          height: 55,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),

          padding: const EdgeInsets.all(7),

          child: Image.asset(
            gambar,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          judul,
          textAlign: TextAlign.center,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}