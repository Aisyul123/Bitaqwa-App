import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';

class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  @override
  State<JadwalSholatScreen> createState() =>
      _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  static const Color peach = Color(0xFFF28F70);
  static const Color skyBlue = Color(0xFFE5F3FC);
  static const Color skyDark = Color(0xFF6D8794);

  Timer? timer;

  DateTime sekarang = DateTime.now();

  String lokasi = 'Mendeteksi lokasi...';
  String status = 'Memuat jadwal salat...';
  bool loadingLokasi = true;

  List<Map<String, String>> jadwal = [];

  String namaSalatBerikutnya = '';
  DateTime? waktuSalatBerikutnya;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        setState(() {
          sekarang = DateTime.now();
          perbaruiSalatBerikutnya();
        });
      },
    );

    ambilLokasi();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatJam(DateTime waktu) {
    final jam = waktu.hour.toString().padLeft(2, '0');
    final menit = waktu.minute.toString().padLeft(2, '0');

    return '$jam:$menit';
  }

  String formatTanggal(DateTime waktu) {
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${hari[waktu.weekday - 1]}, '
        '${waktu.day} ${bulan[waktu.month - 1]} '
        '${waktu.year}';
  }

  Future<void> ambilLokasi() async {
    if (!mounted) return;

    setState(() {
      loadingLokasi = true;
      status = 'Meminta akses lokasi...';
    });

    try {
      final aktif = await Geolocator.isLocationServiceEnabled();

      if (!aktif) {
        throw Exception(
          'GPS belum aktif. Aktifkan lokasi perangkat.',
        );
      }

      LocationPermission izin =
          await Geolocator.checkPermission();

      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }

      if (izin == LocationPermission.denied) {
        throw Exception('Izin lokasi belum diberikan.');
      }

      if (izin == LocationPermission.deniedForever) {
        throw Exception(
          'Izin lokasi ditolak permanen. '
          'Aktifkan melalui pengaturan aplikasi.',
        );
      }

      final posisi = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 20),
        ),
      );

      String namaLokasi =
          '${posisi.latitude.toStringAsFixed(4)}, '
          '${posisi.longitude.toStringAsFixed(4)}';

      try {
        final geocoding = Geocoding();
        final List<Placemark> daftarTempat =
            await geocoding.placemarkFromCoordinates(
          posisi.latitude,
          posisi.longitude,
        );

        if (daftarTempat.isNotEmpty) {
          final tempat = daftarTempat.first;

          namaLokasi = tempat.subLocality?.isNotEmpty == true
              ? tempat.subLocality!
              : tempat.locality?.isNotEmpty == true
                  ? tempat.locality!
                  : tempat.subAdministrativeArea?.isNotEmpty == true
                      ? tempat.subAdministrativeArea!
                      : namaLokasi;
        }
      } catch (_) {
        // Jika nama lokasi gagal ditemukan,
        // koordinat GPS tetap digunakan.
      }

      final koordinat = Coordinates(
        posisi.latitude,
        posisi.longitude,
      );

      final parameter =
          CalculationMethod.muslim_world_league.getParameters();

      final waktuSalat = PrayerTimes(
        koordinat,
        DateComponents.from(sekarang),
        parameter,
      );

      final dataJadwal = <Map<String, String>>[
        {
          'nama': 'Subuh',
          'waktu': formatJam(waktuSalat.fajr),
        },
        {
          'nama': 'Dzuhur',
          'waktu': formatJam(waktuSalat.dhuhr),
        },
        {
          'nama': 'Ashar',
          'waktu': formatJam(waktuSalat.asr),
        },
        {
          'nama': 'Maghrib',
          'waktu': formatJam(waktuSalat.maghrib),
        },
        {
          'nama': 'Isya',
          'waktu': formatJam(waktuSalat.isha),
        },
      ];

      if (!mounted) return;

      setState(() {
        lokasi = namaLokasi;
        jadwal = dataJadwal;
        loadingLokasi = false;
        status = 'Jadwal salat hari ini';
        perbaruiSalatBerikutnya();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingLokasi = false;
        status = e.toString().replaceFirst('Exception: ', '');
        jadwal = [];
        namaSalatBerikutnya = '';
        waktuSalatBerikutnya = null;
      });
    }
  }

  void perbaruiSalatBerikutnya() {
    if (jadwal.isEmpty) return;

    final waktuSalat = <MapEntry<String, DateTime>>[];

    for (final item in jadwal) {
      final bagian = item['waktu']!.split(':');

      final waktu = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day,
        int.parse(bagian[0]),
        int.parse(bagian[1]),
      );

      waktuSalat.add(MapEntry(item['nama']!, waktu));
    }

    MapEntry<String, DateTime>? berikutnya;

    for (final item in waktuSalat) {
      if (item.value.isAfter(sekarang)) {
        berikutnya = item;
        break;
      }
    }

    if (berikutnya == null) {
      // Semua salat hari ini sudah lewat.
      // Hitung Subuh untuk hari berikutnya.
      final posisiWaktu = jadwal.first['waktu']!.split(':');

      namaSalatBerikutnya = 'Subuh';

      waktuSalatBerikutnya = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day + 1,
        int.parse(posisiWaktu[0]),
        int.parse(posisiWaktu[1]),
      );
    } else {
      namaSalatBerikutnya = berikutnya.key;
      waktuSalatBerikutnya = berikutnya.value;
    }

  }

  String hitungMundur() {
    if (waktuSalatBerikutnya == null) {
      return '--:--:--';
    }

    final selisih = waktuSalatBerikutnya!.difference(sekarang);

    if (selisih.isNegative) return '--:--:--';

    final jam = selisih.inHours.toString().padLeft(2, '0');
    final menit =
        (selisih.inMinutes % 60).toString().padLeft(2, '0');
    final detik =
        (selisih.inSeconds % 60).toString().padLeft(2, '0');

    return '$jam:$menit:$detik';
  }

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: skyBlue,
      appBar: AppBar(
        backgroundColor: peach,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Jadwal Sholat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_jadwal.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: skyBlue,
                );
              },
            ),
          ),

          // KONTEN
          RefreshIndicator(
            onRefresh: ambilLokasi,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // BAGIAN LANGIT
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20, 24, 20, 35,
                  ),
                  decoration: const BoxDecoration(
                    color: skyDark,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        formatTanggal(sekarang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        namaSalatBerikutnya.isEmpty
                            ? status
                            : 'Menuju waktu $namaSalatBerikutnya',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatJam(sekarang),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFFF9478),
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              lokasi,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (namaSalatBerikutnya.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Text(
                          'Waktu tersisa ${hitungMundur()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      if (loadingLokasi) ...[
                        const SizedBox(height: 15),
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),

                // KARTU JADWAL
                Transform.translate(
                  offset: const Offset(0, -4),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: lebar < 500 ? 20 : 50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: jadwal.isEmpty
                        ? Column(
                            children: [
                              Text(
                                status,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: ambilLokasi,
                                icon: const Icon(Icons.my_location),
                                label: const Text('Coba lagi'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: peach,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: jadwal.map((item) {
                              final aktif =
                                  item['nama'] == namaSalatBerikutnya;

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFBFE3D8),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['nama']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: aktif
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: aktif
                                              ? peach
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['waktu']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: aktif
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: aktif
                                            ? peach
                                            : Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      aktif
                                          ? Icons.notifications_active
                                          : Icons.access_alarm,
                                      size: 23,
                                      color: aktif
                                          ? peach
                                          : const Color(0xFFFFBD67),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'Jadwal dihitung berdasarkan lokasi GPS '
                    'dan metode Muslim World League.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}