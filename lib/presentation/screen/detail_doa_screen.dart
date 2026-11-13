import 'package:flutter/material.dart';

class DetailDoaScreen extends StatelessWidget {
  final String judul;
  final String doaArab;
  final String arti;
  final String reference;

  const DetailDoaScreen({
    super.key,
    required this.judul,
    required this.doaArab,
    required this.arti,
    required this.reference,
  });

  static const Color peach = Color(0xfff18f70);
  static const Color darkBrown = Color(0xff57443d);
  static const Color softPeach = Color(0xffffeee7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff48384f),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          judul,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // BACKGROUND AMAN JIKA GAMBAR TIDAK DITEMUKAN
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_doa.png',
            fit: BoxFit.cover,
          ),

          // LAPISAN GELAP AGAR TEKS TERBACA
          Container(
            color: const Color(0xff302538).withValues(alpha: 0.20),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // IKON DOA
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: peach,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // JUDUL DOA
                  Text(
                    judul,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'PoppinsMedium',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // KARTU ISI DOA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 26,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfffffdfb),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _sectionTitle('Bacaan Doa'),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            doaArab.isEmpty
                                ? 'Teks doa belum tersedia.'
                                : doaArab,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 29,
                              height: 2.1,
                              color: darkBrown,
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        _divider(),

                        const SizedBox(height: 22),

                        _sectionTitle('Artinya'),

                        const SizedBox(height: 12),

                        Text(
                          arti.isEmpty
                              ? 'Terjemahan belum tersedia.'
                              : arti,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.9,
                            color: darkBrown,
                          ),
                        ),

                        const SizedBox(height: 26),

                        _divider(),

                        const SizedBox(height: 22),

                        _sectionTitle('Referensi'),

                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: softPeach,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            reference.isEmpty
                                ? 'Referensi belum tersedia.'
                                : reference,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.7,
                              color: darkBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Semoga bermanfaat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PoppinsMedium',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: peach,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: peach.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: peach.withValues(alpha: 0.2),
    );
  }
}