import 'package:flutter/material.dart';
import 'verify_otp_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Otomatis pindah ke Halaman Verify OTP setelah 2.5 detik
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _goToNext();
      }
    });
  }

  void _goToNext() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const VerifyOtpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToNext,
      child: Scaffold(
        backgroundColor: const Color(0xFFBE00FF),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393), // Presisi ukuran layar iPhone 16
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ==========================================
                // 1. BACKGROUND ASLI DARI FIGMA (1000% PERSIS & PIXEL-PERFECT)
                // ==========================================
                Image.asset(
                  'assets/images/splash_bg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/Splash Screen.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),

                // ==========================================
                // 2. LOGO ASLI FIGMA DI TENGAH (DOMPET + XEMA)
                // ==========================================
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150, // Ukuran proporsional di tengah layar
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 65,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'xema',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
