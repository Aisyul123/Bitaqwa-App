import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final TextEditingController hartaController =
      TextEditingController(text: '345325352');

  final NumberFormat rupiahInput = NumberFormat('#,##0', 'id_ID');
  final NumberFormat rupiahOutput =
      NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp. ',
        decimalDigits: 2,
      );

  double totalHarta = 345325352;
  double zakat = 0;

  @override
  void initState() {
    super.initState();
    hitungZakat();
  }

  void hitungZakat() {
    zakat = totalHarta * 0.025;
  }

  void prosesHarta() {
    final angka = hartaController.text.replaceAll('.', '').replaceAll(',', '');

    setState(() {
      totalHarta = double.tryParse(angka) ?? 0;
      hitungZakat();
      hartaController.text = rupiahInput.format(totalHarta);
    });

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    hartaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF28F70),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Zakat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // GAMBAR ZAKAT
              SizedBox(
                height: 205,
                child: Image.asset(
                  'assets/images/zakat.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.volunteer_activism,
                      size: 110,
                      color: Color(0xFF484778),
                    );
                  },
                ),
              ),

              const SizedBox(height: 34),

              // INPUT TOTAL HARTA
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Harta',
                      style: TextStyle(
                        color: Color(0xFFF28F70),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: hartaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Masukkan Total Harta',
                        labelStyle: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                        prefixText: 'Rp. ',
                        prefixStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF7043),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFFF28F70),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 13),

                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton(
                        onPressed: prosesHarta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28F70),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // TOTAL UANG
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97878),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Uang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      rupiahOutput.format(totalHarta),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ZAKAT DIKELUARKAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB066C4),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Zakat Dikeluarkan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      rupiahOutput.format(zakat),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}