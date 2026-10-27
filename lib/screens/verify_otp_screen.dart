import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personal_details_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // Variabel State yang mengontrol 6 digit OTP
  String _otpCode = '';

  // AWALNYA KEYBOARD TIDAK MUNCUL (Sesuai Desain Awal Figma)
  bool _isKeyboardVisible = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += value;
      });
    }
  }

  void _onBackspace() {
    if (_otpCode.isNotEmpty) {
      setState(() {
        _otpCode = _otpCode.substring(0, _otpCode.length - 1);
      });
    }
  }

  void _onSubmitOtp() {
    if (_otpCode.length == 6) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 60),
            ),
            const SizedBox(height: 18),
            Text(
              'Verifikasi Berhasil!',
              style: GoogleFonts.rasa(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode OTP $_otpCode valid. Masuk ke halaman selanjutnya...',
              textAlign: TextAlign.center,
              style: GoogleFonts.rasa(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PersonalDetailsScreen()),
        );
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _otpCode.length == 6;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            _onBackspace();
          } else if (event.logicalKey == LogicalKeyboardKey.enter && isCompleted) {
            _onSubmitOtp();
          } else {
            final char = event.character;
            if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
              if (!_isKeyboardVisible) {
                setState(() {
                  _isKeyboardVisible = true;
                });
              }
              _onKeyPress(char);
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 393), // Ukuran presisi iPhone 16
              child: GestureDetector(
                // Ketuk area luar untuk menutup keyboard jika sedang terbuka
                onTap: () {
                  if (_isKeyboardVisible) {
                    setState(() {
                      _isKeyboardVisible = false;
                    });
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    // ==========================================
                    // 1. TOP BAR: CHEVRON & TITLE
                    // HEADER "Verify OTP" -> FONT POCHAEVSK
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verify OTP',
                            style: GoogleFonts.pochaevsk(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),

                              // ==========================================
                              // 2. ILUSTRASI DUA ELIPS MIRING KE SUDUT KANAN ATAS (↗)
                              // ==========================================
                              _buildOtpIllustrationExactDiagonal(),

                              const SizedBox(height: 20),

                              // ==========================================
                              // 3. TEKS PENJELASAN (STRING -> FONT RASA)
                              // ==========================================
                              Text(
                                'We have just sent a 6 digit code to your\nentered number. Enter the code below.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rasa(
                                  fontSize: 15,
                                  color: const Color(0xFF4A1565), // Warna ungu tua sesuai Figma
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 26),

                              // ==========================================
                              // 4. 6 KOTAK OTP (INT/ANGKA -> TETAP POPPINS)
                              // KETUK KOTAK UNTUK MEMUNCULKAN KEYBOARD!
                              // ==========================================
                              _buildOtpBoxes(),

                              const SizedBox(height: 20),

                              // ==========================================
                              // 5. TEKS RESEND (STRING -> FONT RASA)
                              // ==========================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive any code? ",
                                    style: GoogleFonts.rasa(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Kode OTP baru telah dikirim!',
                                            style: GoogleFonts.rasa(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Resend',
                                      style: GoogleFonts.rasa(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFC040FB),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ==========================================
                    // 6. KEYPAD NUMERIK (AWALNYA TERSEMBUNYI,
                    // MUNCUL KETIKA KOTAK OTP DIKETUK)
                    // ==========================================
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        );
                      },
                      child: _isKeyboardVisible
                          ? _buildCustomKeypad(isCompleted: isCompleted)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ILUSTRASI DUA ELIPS MIRING PERSIS KE ARAH SUDUT KANAN ATAS (↗)
  // Sesuai screenshot Figma:
  // - Elips 1 (Luar): W: 320.8, H: 189.97, Rotasi: -19.7°
  // - Elips 2 (Dalam): W: 316.92, H: 181.61, Rotasi: -39.71°
  // ==========================================
  Widget _buildOtpIllustrationExactDiagonal() {
    return SizedBox(
      height: 240,
      width: 360,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. ELIPS DI BELAKANG (TRANSPARAN / OPACITY SESUAI PERMINTAAN)
          // Kode warna: #490460 / #490046 (Kode 49046) dengan transparansi (alpha: 0.50)
          Transform.rotate(
            angle: -19.7 * math.pi / 180,
            child: Container(
              width: 320.8 * 0.90,
              height: 189.97 * 0.90,
              decoration: BoxDecoration(
                color: const Color(0xFF490460).withValues(alpha: 0.50), // Transparan di belakang
                borderRadius: const BorderRadius.all(
                  Radius.elliptical(320.8 * 0.90, 189.97 * 0.90),
                ),
              ),
            ),
          ),

          // 2. ELIPS DI DEPAN (SOLID / TIDAK TRANSPARAN)
          // Menggunakan warna ungu Figma solid (#B024DF) di depan elips transparan
          Transform.rotate(
            angle: -39.71 * math.pi / 180,
            child: Container(
              width: 316.92 * 0.90,
              height: 181.61 * 0.90,
              decoration: BoxDecoration(
                color: const Color(0xFFB024DF), // Warna solid di depan
                borderRadius: const BorderRadius.all(
                  Radius.elliptical(316.92 * 0.90, 181.61 * 0.90),
                ),
              ),
            ),
          ),

          // 3. GAMBAR ASLI TANGAN + HP DARI FIGMA DI TENGAH-TENGAH
          Center(
            child: Image.asset(
              'assets/images/logo_verify_otp.png',
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/verify_otp.png',
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/ify-removebg-preview 1.png',
                      height: 180,
                      fit: BoxFit.contain,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6 KOTAK KODE OTP (ANGKA -> TETAP FONT POPPINS)
  // KETUK KOTAK INI UNTUK MEMUNCULKAN KEYBOARD
  // ==========================================
  Widget _buildOtpBoxes() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isKeyboardVisible = true;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          final hasValue = index < _otpCode.length;
          final isCurrent = index == _otpCode.length && _isKeyboardVisible;
          final char = hasValue ? _otpCode[index] : '';

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFFC040FB) // Highlight ungu saat kotak aktif
                    : (hasValue ? const Color(0xFF0084FF) : Colors.grey.shade300),
                width: (isCurrent || hasValue) ? 2 : 1.2,
              ),
              boxShadow: (isCurrent || hasValue)
                  ? [
                      BoxShadow(
                        color: (isCurrent ? const Color(0xFFC040FB) : const Color(0xFF0084FF))
                            .withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Text(
              char,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // KEYPAD NUMERIK (ANGKA -> TETAP FONT POPPINS)
  // ==========================================
  Widget _buildCustomKeypad({required bool isCompleted}) {
    final List<List<String>> keypadRows = [
      ['1', '2', '3', '-'],
      ['4', '5', '6', '<'],
      ['7', '8', '9', '^'],
      [',', '0', '.', 'CHECK'], // CHECK = Tombol Centang
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar kecil untuk menutup keyboard jika disentuh
          GestureDetector(
            onTap: () {
              setState(() {
                _isKeyboardVisible = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          ...keypadRows.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((key) {
                  return _buildKeypadButton(key, isCompleted: isCompleted);
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  // TOMBOL KEYPAD INDIVIDUAL
  Widget _buildKeypadButton(String label, {required bool isCompleted}) {
    final bool isAction = label == '<' || label == 'CHECK' || label == '-' || label == '^';
    final bool isCheckButton = label == 'CHECK';

    // RECTANGLE TOMBOL CENTANG TETAP SELALU WARNA PUTIH!
    Color buttonColor;
    if (isCheckButton) {
      buttonColor = Colors.white; // Kotak tetap putih
    } else if (isAction) {
      buttonColor = const Color(0xFFE5E5EA);
    } else {
      buttonColor = Colors.white;
    }

    return SizedBox(
      width: 78,
      height: 48,
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (label == '<') {
              _onBackspace();
            } else if (label == 'CHECK') {
              if (isCompleted) {
                _onSubmitOtp();
              }
            } else if (label != '-' && label != '^') {
              _onKeyPress(label);
            }
          },
          child: Center(
            child: label == '<'
                ? const Icon(Icons.backspace_outlined, size: 20, color: Colors.black87)
                : label == 'CHECK'
                    ? Icon(
                        Icons.check,
                        size: 24,
                        color: isCompleted ? Colors.black : Colors.grey.shade400,
                      )
                    : Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
