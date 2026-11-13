import 'package:flutter/material.dart';
import 'package:bitaqwa_app/enum/kategori_doa_enum.dart';
import 'package:bitaqwa_app/extention/kategori_doa_ext.dart';
import 'package:bitaqwa_app/data/dummy/doa_data.dart';
import 'package:bitaqwa_app/presentation/screen/detail_doa_screen.dart';

class DoaListScreen extends StatelessWidget {
  final DoaCategory category;

  const DoaListScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final doaList = doaData[category] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfffaf5fb),
      appBar: AppBar(
        backgroundColor: const Color(0xfff18f70),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: doaList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada doa untuk kategori ini.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemCount: doaList.length,
              itemBuilder: (context, index) {
                final doa = doaList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailDoaScreen(
                            judul: doa.title,
                            doaArab: doa.arabicText,
                            arti: doa.translation,
                            reference: doa.reference,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            doa.image,
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                width: 48,
                                height: 48,
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  size: 32,
                                  color: Color(0xfff18f70),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doa.title,
                              style: const TextStyle(
                                fontFamily: 'PoppinsMedium',
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xfff18f70),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}