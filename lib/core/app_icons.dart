import 'package:flutter/material.dart';

/// Kelas terpusat untuk seluruh asset ikon aplikasi XEMA
/// Menggabungkan ikon custom Figma & ikon bawaan agar rapi dan mudah dirawat.
class AppIcons {
  // Asset path folder
  static const String _iconsPath = 'assets/icons';
  static const String _imagesPath = 'assets/images';

  // Custom Figma PNG Icons
  static const String avatarRecipient = '$_iconsPath/avatar_recipient.png';
  static const String icSuccessTick = '$_iconsPath/ic_success_tick.png';
  static const String icShare = '$_iconsPath/ic_share.png';

  // Bank Logos (Figma Official Assets)
  static const String logoBca = '$_imagesPath/logo_bca.png';
  static const String logoBri = '$_imagesPath/logo_bri.png';
  static const String logoMandiri = '$_imagesPath/logo_mandiri.png';
  static const String logoBni = '$_imagesPath/logo_bni.png';
  static const String logoBsi = '$_imagesPath/logo_bsi.png';
  static const String logoBtn = '$_imagesPath/logo_btn.png';
  static const String logoSeaBank = '$_imagesPath/logo_seabank.png';
  static const String logoBas = '$_imagesPath/logo_bas.png';
  static const String logoPermata = '$_imagesPath/logo_permata.png';
  static const String logoCimb = '$_imagesPath/logo_cimb.png';

  // Regional Bank Logos (Figma Frame 103:296 Official Assets)
  static const String logoBankAceh = '$_imagesPath/logo_bank_aceh.png';
  static const String logoBankBanten = '$_imagesPath/logo_bank_banten.png';
  static const String logoBankBengkulu = '$_imagesPath/logo_bank_bengkulu.png';
  static const String logoBankBjb = '$_imagesPath/logo_bank_bjb.png';
  static const String logoBankJambi = '$_imagesPath/logo_bank_jambi.png';
  static const String logoBankJateng = '$_imagesPath/logo_bank_jateng.png';
  static const String logoBankJatim = '$_imagesPath/logo_bank_jatim.png';
  static const String logoBankKalbar = '$_imagesPath/logo_bank_kalbar.png';
  static const String logoBankKalsel = '$_imagesPath/logo_bank_kalsel.png';
  static const String logoBankLampung = '$_imagesPath/logo_bank_lampung.png';
  static const String logoBankMaluku = '$_imagesPath/logo_bank_maluku.png';
  static const String logoBankNtt = '$_imagesPath/logo_bank_ntt.png';
  static const String logoBankPapua = '$_imagesPath/logo_bank_papua.png';
  static const String logoBankBali = '$_imagesPath/logo_bank_bali.png';
  static const String logoBankSulteng = '$_imagesPath/logo_bank_sulteng.png';
  static const String logoBankSumut = '$_imagesPath/logo_bank_sumut.png';

  // Retail Logos (Figma Official Assets)
  static const String logoIndomaret = '$_imagesPath/logo_indomaret.png';
  static const String logoAlfamart = '$_imagesPath/logo_alfamart.png';
  static const String logoPos = '$_imagesPath/logo_pos.png';

  // Helper widget untuk merender logo bank/icon dengan fallback anggun jika file belum termuat
  static Widget buildImageOrIcon(
    String assetPath, {
    double width = 36,
    double height = 36,
    IconData fallbackIcon = Icons.account_balance,
    Color fallbackColor = const Color(0xFF772096),
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: width * 0.75, color: fallbackColor);
      },
    );
  }
}
