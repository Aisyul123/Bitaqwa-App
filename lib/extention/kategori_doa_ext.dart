
import 'package:bitaqwa_app/enum/kategori_doa_enum.dart';

extension DoaCategoryExtension on DoaCategory {
  String get title {
    if (this == DoaCategory.makananMinuman) {
      return 'Makanan & Minuman';
    }
    if (this == DoaCategory.pagiMalam) {
      return 'Pagi & Malam';
    }
    if (this == DoaCategory.rumah) {
      return 'Rumah';
    }
    if (this == DoaCategory.perjalanan) {
      return 'Perjalanan';
    }
    if (this == DoaCategory.sholat) {
      return 'Sholat';
    }
    if (this == DoaCategory.etikaBaik) {
      return 'Etika Baik';
    }

    return 'Doa-doa';
  }

  String get image {
    if (this == DoaCategory.makananMinuman) {
      return 'assets/images/MakanMinum.png';
    }
    if (this == DoaCategory.pagiMalam) {
      return 'assets/images/PagiMalam.png';
    }
    if (this == DoaCategory.rumah) {
      return 'assets/images/Rumah.png';
    }
    if (this == DoaCategory.perjalanan) {
      return 'assets/images/Perjalanan.png';
    }
    if (this == DoaCategory.sholat) {
      return 'assets/images/Sholat.png';
    }
    if (this == DoaCategory.etikaBaik) {
      return 'assets/images/Etika.png';
    }

    return 'assets/images/PagiMalam.png';
  }
}
