import 'package:flutter/material.dart';
import 'package:bitaqwa_app/enum/kategori_doa_enum.dart';
import 'package:bitaqwa_app/presentation/screen/doa_list_screen.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final List<Map<String, String>> daftarDoa = [
    {
      'judul': 'Pagi & Malam',
      'gambar': 'assets/images/PagiMalam.png',
      'route': '/doa/pagi-malam',
    },
    {
      'judul': 'Rumah',
      'gambar': 'assets/images/Rumah.png',
      'route': '/doa/rumah',
    },
    {
      'judul': 'Makanan & Minuman',
      'gambar': 'assets/images/MakanMinum.png',
      'route': '/doa/makanan',
    },
    {
      'judul': 'Perjalanan',
      'gambar': 'assets/images/Perjalanan.png',
      'route': '/doa/perjalanan',
    },
    {
      'judul': 'Sholat',
      'gambar': 'assets/images/Sholat.png',
      'route': '/doa/sholat',
    },
    {
      'judul': 'Etika Baik',
      'gambar': 'assets/images/Etika.png',
      'route': '/doa/etika',
    },
  ];

  DoaCategory? getKategori(String? route) {
    switch (route) {
      case '/doa/pagi-malam':
        return DoaCategory.pagiMalam;
      case '/doa/rumah':
        return DoaCategory.rumah;
      case '/doa/makanan':
        return DoaCategory.makananMinuman;
      case '/doa/perjalanan':
        return DoaCategory.perjalanan;
      case '/doa/sholat':
        return DoaCategory.sholat;
      case '/doa/etika':
        return DoaCategory.etikaBaik;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF28F70),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Doa-doa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final lebar = constraints.maxWidth;
            final jumlahKolom = lebar >= 700 ? 4 : 3;
            final paddingSamping = lebar >= 700 ? 24.0 : 8.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BANNER
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: lebar >= 700 ? 40 : 35,
                      vertical: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/background_pagi.png',
                        width: double.infinity,
                        height: lebar >= 700 ? 230 : 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: lebar >= 700 ? 230 : 180,
                            color: const Color(0xFFDDF2FC),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.landscape,
                                  size: 55,
                                  color: Color(0xFF80B6C9),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Banner Doa',
                                  style: TextStyle(
                                    color: Color(0xFF527D8D),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // JUDUL KATEGORI
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: lebar >= 700 ? 24 : 16,
                    ),
                    child: const Text(
                      'Kategori Doa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF45404A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // GRID KATEGORI
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingSamping,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daftarDoa.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        childAspectRatio: lebar >= 700 ? 0.95 : 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final doa = daftarDoa[index];

                        return KategoriDoaCard(
                          judul: doa['judul']!,
                          gambar: doa['gambar']!,
                          warna: warnaKategori(index),
                          onTap: () {
                            final category =
                                getKategori(doa['route']);

                            if (category == null) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DoaListScreen(
                                    category: category,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color warnaKategori(int index) {
    const warna = [
      Color(0xFFDDF2FC),
      Color(0xFFFFE9C9),
      Color(0xFFF3D4F7),
      Color(0xFFFFD9D5),
      Color(0xFFCDEFE8),
      Color(0xFFFFF0B9),
    ];

    return warna[index % warna.length];
  }
}

class KategoriDoaCard extends StatefulWidget {
  final String judul;
  final String gambar;
  final Color warna;
  final VoidCallback onTap;

  const KategoriDoaCard({
    super.key,
    required this.judul,
    required this.gambar,
    required this.warna,
    required this.onTap,
  });

  @override
  State<KategoriDoaCard> createState() => _KategoriDoaCardState();
}

class _KategoriDoaCardState extends State<KategoriDoaCard> {
  bool ditekan = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => ditekan = true);
      },
      onTapCancel: () {
        setState(() => ditekan = false);
      },
      onTapUp: (_) {
        setState(() => ditekan = false);
      },
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: ditekan ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ditekan
                  ? widget.warna
                  : const Color(0xFFF1EBF2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: ditekan ? 2 : 5,
                offset: Offset(0, ditekan ? 1 : 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 120,
                        maxHeight: 120,
                      ),
                      color: widget.warna,
                      child: Image.asset(
                        widget.gambar,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: Colors.grey.shade500,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    widget.judul,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF39343D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}