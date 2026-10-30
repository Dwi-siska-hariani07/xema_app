import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Nilai awal dibuat kosong sesuai permintaan user
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _gmailController = TextEditingController(text: '');
  final TextEditingController _addressController = TextEditingController(text: '');

  // Status keyboard in-app dan field yang sedang aktif
  bool isKeyboardOpen = false;
  String activeField = ''; // 'name', 'gmail', 'address'

  // Status modal popup dialog "Personal Succes"
  bool _showSuccessPopup = false;

  // Warna Presisi Sesuai Figma
  final Color figmaPurple = const Color(0xFFE498FF); // #E498FF warna ungu sudut Figma
  final Color titlePurple = const Color(0xFF1C0823); // Judul Personal Details
  final Color descPurple = const Color(0xFF1E1E1E); // Teks deskripsi
  final Color inputBorderColor = const Color(0xFFD9D9D9); // Border kotak input
  final Color iconPurple = const Color(0xFF772096); // Warna ikon profil ungu
  final Color saveBtnActive = const Color(0xFF9024B5); // #9024B5 Ungu solid Figma Save Button
  final Color saveBtnDisabled = const Color(0xFFD185EC); // #D185EC Ungu saat dialog muncul

  @override
  void dispose() {
    _nameController.dispose();
    _gmailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onKeyPress(String char) {
    setState(() {
      if (activeField == 'name') {
        _nameController.text += char;
      } else if (activeField == 'gmail') {
        _gmailController.text += char;
      } else if (activeField == 'address') {
        _addressController.text += char;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (activeField == 'name' && _nameController.text.isNotEmpty) {
        _nameController.text =
            _nameController.text.substring(0, _nameController.text.length - 1);
      } else if (activeField == 'gmail' && _gmailController.text.isNotEmpty) {
        _gmailController.text =
            _gmailController.text.substring(0, _gmailController.text.length - 1);
      } else if (activeField == 'address' && _addressController.text.isNotEmpty) {
        _addressController.text =
            _addressController.text.substring(0, _addressController.text.length - 1);
      }
    });
  }

  void _onCloseKeyboard() {
    setState(() {
      isKeyboardOpen = false;
      activeField = '';
    });
  }

  void _onSavePressed() {
    setState(() {
      isKeyboardOpen = false;
      _showSuccessPopup = true;
    });
  }

  void _onClosePopup() {
    setState(() {
      _showSuccessPopup = false;
    });
    // Setelah popup Personal Success ditutup / diklik, alur lanjut ke Konfirmasi PIN
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PinScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: SizedBox(
            // Kanvas presisi 1:1 Figma (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =============================================================
                // 1. ELEMEN FIGMA: LENGKUNGAN UNGU KIRI ATAS (BERSIH TANPA TEKS)
                // =============================================================
                Positioned(
                  top: -85,
                  left: -85,
                  width: 330,
                  height: 240,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(330 / 2, 240 / 2),
                      ),
                      color: figmaPurple,
                    ),
                  ),
                ),

                // =============================================================
                // 2. ELEMEN FIGMA: LENGKUNGAN UNGU KANAN BAWAH (BERSIH DARI FIGMA)
                // =============================================================
                Positioned(
                  bottom: 0,
                  right: 0,
                  width: 336,
                  height: 157,
                  child: Image.asset(
                    'assets/images/figma_personal_bot_curve_clean.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 3. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Personal Details"
                // =============================================================
                Positioned(
                  top: 57,
                  left: 14,
                  right: 20,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Personal Details',
                        style: GoogleFonts.pochaevsk(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          color: titlePurple,
                          shadows: const [
                            BoxShadow(
                              color: Color(0x35000000),
                              offset: Offset(0, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // 4. TEKS DESKRIPSI (2 BARIS):
                // "Your personal information eill helps our service to reach you easily"
                // =============================================================
                Positioned(
                  top: 135,
                  left: 30,
                  right: 30,
                  child: Text(
                    'Your personal information eill helps our service to reach you easily',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rasa(
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.normal,
                      color: descPurple,
                    ),
                  ),
                ),

                // =============================================================
                // 5. AVATAR LILAC LINGKARAN DENGAN IKON USER
                // =============================================================
                Positioned(
                  top: 205,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/figma_personal_avatar.png',
                      width: 105,
                      height: 105,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =============================================================
                // 6. INPUT 1: "Full name"
                // =============================================================
                Positioned(
                  top: 338,
                  left: 18,
                  width: 357,
                  height: 58,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeField = 'name';
                        isKeyboardOpen = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: activeField == 'name'
                              ? const Color(0xFFCA31FF)
                              : inputBorderColor,
                          width: activeField == 'name' ? 1.8 : 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 24,
                            color: iconPurple.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _nameController.text.isEmpty
                                  ? 'Full name'
                                  : _nameController.text,
                              style: GoogleFonts.rasa(
                                fontSize: 18,
                                color: _nameController.text.isEmpty
                                    ? const Color(0xFF757575)
                                    : const Color(0xFF1E1E1E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 7. INPUT 2: "Gmail"
                // =============================================================
                Positioned(
                  top: 424,
                  left: 18,
                  width: 357,
                  height: 58,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeField = 'gmail';
                        isKeyboardOpen = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: activeField == 'gmail'
                              ? const Color(0xFFCA31FF)
                              : inputBorderColor,
                          width: activeField == 'gmail' ? 1.8 : 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.mail_rounded,
                            size: 24,
                            color: Color(0xFF1E1E1E),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _gmailController.text.isEmpty
                                  ? 'Gmail'
                                  : _gmailController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1E1E1E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 8. INPUT 3: "Address"
                // =============================================================
                Positioned(
                  top: 510,
                  left: 18,
                  width: 357,
                  height: 58,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeField = 'address';
                        isKeyboardOpen = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: activeField == 'address'
                              ? const Color(0xFFCA31FF)
                              : inputBorderColor,
                          width: activeField == 'address' ? 1.8 : 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 24,
                            color: Color(0xFF1E1E1E),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _addressController.text.isEmpty
                                  ? 'Address'
                                  : _addressController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1E1E1E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 9. TOMBOL "Save" (Warna Ungu Solid #9024B5 Persis Gambar Figma)
                // =============================================================
                Positioned(
                  top: 618,
                  left: 36,
                  width: 326,
                  height: 55,
                  child: GestureDetector(
                    onTap: _onSavePressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _showSuccessPopup ? saveBtnDisabled : saveBtnActive,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF1C0823),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: saveBtnActive.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 10. KEYBOARD IN-APP (Muncul saat field input diklik)
                // =============================================================
                if (isKeyboardOpen)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F5FA),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activeField == 'name'
                                    ? 'Masukkan Nama Lengkap'
                                    : (activeField == 'gmail'
                                        ? 'Masukkan Alamat Email'
                                        : 'Masukkan Alamat Tempat Tinggal'),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF570374),
                                ),
                              ),
                              GestureDetector(
                                onTap: _onCloseKeyboard,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCA31FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Selesai',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Preset Cepat Figma / Keyboard Virtual
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuickChip('Lisa Arunia', () {
                                _nameController.text = 'Lisa Arunia';
                                setState(() {});
                              }),
                              _buildQuickChip('lisaarunia@gmail.com', () {
                                _gmailController.text = 'lisaarunia@gmail.com';
                                setState(() {});
                              }),
                              _buildQuickChip('Bandung', () {
                                _addressController.text = 'Bandung';
                                setState(() {});
                              }),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Baris Huruf Virtual QWERTY
                          _buildLetterRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
                          const SizedBox(height: 6),
                          _buildLetterRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...['Z', 'X', 'C', 'V', 'B', 'N', 'M'].map((ch) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                  child: _buildKeyBtn(ch, () => _onKeyPress(ch.toLowerCase())),
                                );
                              }),
                              const SizedBox(width: 4),
                              _buildKeyBtn('⌫', _onDelete, isSpecial: true),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildKeyBtn('@gmail.com', () => _onKeyPress('@gmail.com'), isSpecial: true, width: 100),
                              const SizedBox(width: 6),
                              _buildKeyBtn('Spasi', () => _onKeyPress(' '), isSpecial: true, width: 120),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // =============================================================
                // 11. ELEMEN SEBELAHNYA: MODAL POPUP "Personal Succes"
                // Tampil di atas layar ketika tombol Save diklik (node #811-1759)
                // =============================================================
                if (_showSuccessPopup) ...[
                  // Dimmed overlay backdrop
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _onClosePopup,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                  // Popup Dialog Card
                  Positioned(
                    top: 290,
                    left: (393 - 265) / 2,
                    width: 265,
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Tombol Close (x) kecil di sudut kanan atas
                          Positioned(
                            top: 12,
                            right: 14,
                            child: GestureDetector(
                              onTap: _onClosePopup,
                              child: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),

                          // Konten Modal: Lingkaran Centang Ungu + Teks "Success"
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: _onClosePopup,
                                  child: Container(
                                    width: 76,
                                    height: 76,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFCA31FF), // Warna ungu centang Figma
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Success',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE9CAF7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF570374),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((l) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: _buildKeyBtn(l, () => _onKeyPress(l.toLowerCase())),
        );
      }).toList(),
    );
  }

  Widget _buildKeyBtn(String label, VoidCallback onTap, {bool isSpecial = false, double width = 30}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 38,
        decoration: BoxDecoration(
          color: isSpecial ? const Color(0xFFD9D9D9) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSpecial ? 11 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF222222),
          ),
        ),
      ),
    );
  }
}
