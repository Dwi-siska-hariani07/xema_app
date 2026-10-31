import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'security_screen.dart';
import 'help_screen.dart';

/// Screen Profil User (Figma Node-ID: 32:2, 529:170, 529:171, 38:162, 38:167, 38:171, 38:174, 38:177, 38:181)
/// 100% Mengikuti spesifikasi nilai presisi dari SVG & Inspeksi Figma:
/// - Header: Fill #CA31FF, Height: 128 + status bar
/// - Ellipses opacity 0.2 #D9D9D9
/// - Capsule Lisa Arunia: X: 21, Y: 58, W: 219, H: 61, R: 25..30.5, Fill: #8F46A8 opacity 0.5
/// - Rectangle 25 (Card Menu): X: 31, Y: 186, W: 336, H: 427, R: 25, Fill #FFFFFF
///   - Stroke: Inside #CA31FF 100% 1px + #000000 20%
///   - Shadow: Drop shadow rgba(213, 56, 249, 0.52) (#D538F9), blur 5, spread 3, offset (0, 4)
///   - Dividers: Y 289.7, Y 393.9, Y 500.0 (stroke #000000 20%)
///   - Font: Poltawski Nowy, SemiBold (w600), 20, Fill #000000
///   - Icons & Arrow color: #52086B
/// - Log Out Button: X: 37, Y: 666, W: 319, H: 46, R: 23, Fill #FFFFFF
///   - Stroke: Inside #CA31FF 100% 1px + #000000 20%
///   - Shadow: rgba(213, 56, 249, 0.52), blur 5, spread 3, offset (0, 4)
///   - Text: Log Out, Poltawski Nowy SemiBold 18, color #FA2323
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Header murni di SVG Figma adalah 128px
    final double headerHeight = 128.0 + statusBarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ===================================================================
            // 1. HEADER SECTION (FIGMA NODE 1520:1759 / 32:2)
            // ===================================================================
            SizedBox(
              width: double.infinity,
              height: headerHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Latar Header Ungu Bersih Tanpa Gelembung/Elips (#CA31FF)
                  Container(
                    color: const Color(0xFFCA31FF),
                  ),

                  // Logo Dompet & Teks "xema" (Node 834:3707)
                  // Logo layout w:152 h:152, position x:230 y:-39
                  // Text xema layout w:64 h:20, position x:327 y:31, font: Rasa Bold 24
                  Positioned(
                    top: statusBarHeight - 39,
                    left: 230,
                    width: 152,
                    height: 152,
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: statusBarHeight + 31,
                    left: 327,
                    width: 64,
                    height: 28,
                    child: Text(
                      'xema',
                      style: GoogleFonts.rasa(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),

                  // Kapsul Oval Profil Lisa Arunia (Node 834:3711)
                  // Dimensi Figma Group: Position X: 21, Y: 58 | Dimensions W: 251, H: 62
                  Positioned(
                    top: statusBarHeight + 58,
                    left: 21,
                    width: 251,
                    height: 62,
                    child: Stack(
                      children: [
                        // 1. Background Kapsul Oval Figma:
                        // d="M0 25C0 11.1929 11.1929 0 25 0H194C207.807 0 219 11.1929 219 25V36C219 49.8071 207.807 61 194 61H25C11.1929 61 0 49.8071 0 36V25Z" fill="#8F46A8" opacity="0.5"
                        Positioned(
                          left: 0,
                          top: 0,
                          width: 219,
                          height: 61,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8F46A8).withOpacity(0.50),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),

                        // 2. Avatar User Asli Figma (Posisi Center: cx=30.5, cy=28.5)
                        // Bounding Box: X: 11, Y: 9, Diameter: 39.4 x 39.4
                        Positioned(
                          left: 11,
                          top: 9,
                          width: 39.4,
                          height: 39.4,
                          child: Image.asset(
                            'assets/profile/figma_avatar_user.png',
                            width: 39.4,
                            height: 39.4,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // 3. Nama "LISA ARUNIA" (Poltawski Nowy Bold, White)
                        // Posisi SVG: X: 64.86, Y: 16.6..31.04
                        Positioned(
                          left: 64.86,
                          top: 13,
                          child: Text(
                            'LISA ARUNIA',
                            style: GoogleFonts.poltawskiNowy(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        // 4. Nomor HP "0851 2343 5656" (#F3D8FF)
                        // Posisi SVG: X: 61.68, Y: 38.8..51.2
                        Positioned(
                          left: 61.68,
                          top: 35,
                          child: Text(
                            '0851 2343 5656',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF3D8FF),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Posisi Y Figma: Dari Header (Y=128) ke Card (Y=186) = 186 - 128 = 58px.
            const SizedBox(height: 58),

            // ===================================================================
            // 2. KARTU MENU UTAMA (FIGMA RECTANGLE 25: NODE 529:171)
            // Layout: W 336, H 427, Corner Radius 25
            // Fill: #FFFFFF
            // Double Stroke Figma: #CA31FF 100% inside 1px & #000000 20%
            // Effects: Drop Shadow rgba(213, 56, 249, 0.52) (#D538F9), blur 5, spread 3, offset (0, 4)
            // ===================================================================
            Center(
              child: Container(
                width: 336,
                height: 427,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFCA31FF),
                    width: 1.0,
                  ),
                  boxShadow: const [
                    // Figma exact drop shadow: filter0_d_32_2
                    // stdDeviation: 2.5 (blurRadius: 5), dx: 0, dy: 4, spread: 3
                    // Color: #D538F9 dengan opacity 0.52 (0x85D538F9)
                    BoxShadow(
                      color: Color(0x85D538F9),
                      blurRadius: 5,
                      offset: Offset(0, 4),
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Row 1: Profil Saya (Tinggi baris ~103.7px)
                    Expanded(
                      flex: 104,
                      child: _buildMenuRow(
                        iconAsset: 'assets/profile/icon_user.png',
                        iconWidth: 32,
                        iconHeight: 34,
                        title: 'Profil Saya',
                        isFirst: true,
                        isLast: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const _FigmaDivider(),

                    // Row 2: Pengaturan (Tinggi baris ~104.2px)
                    Expanded(
                      flex: 104,
                      child: _buildMenuRow(
                        iconAsset: 'assets/profile/icon_gear.png',
                        iconWidth: 36,
                        iconHeight: 36,
                        title: 'Pengaturan',
                        isFirst: false,
                        isLast: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const _FigmaDivider(),

                    // Row 3: Keamanan (Tinggi baris ~106.0px)
                    Expanded(
                      flex: 106,
                      child: _buildMenuRow(
                        iconAsset: 'assets/profile/icon_shield.png',
                        iconWidth: 34,
                        iconHeight: 32,
                        title: 'Keamanan',
                        isFirst: false,
                        isLast: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecurityScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const _FigmaDivider(),

                    // Row 4: Bantuan (Tinggi baris ~113.0px)
                    Expanded(
                      flex: 113,
                      child: _buildMenuRow(
                        iconAsset: 'assets/profile/icon_help.png',
                        iconWidth: 32,
                        iconHeight: 32,
                        title: 'Bantuan',
                        isFirst: false,
                        isLast: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Posisi tombol Log Out di SVG Figma:
            // Card bottom Y = 186 + 427 = 613
            // Log Out top Y = 666
            // Jarak tepat: 666 - 613 = 53px
            const SizedBox(height: 53),

            // ===================================================================
            // 3. TOMBOL LOG OUT (FIGMA NODE 529:170)
            // Layout: W 319, H 46, Corner Radius 23 (rx="23" di SVG)
            // Fill: #FFFFFF
            // Stroke: #CA31FF 100% 1px & #000000 20%
            // Effects: Drop Shadow rgba(213, 56, 249, 0.52), blur 5, spread 3, offset (0, 4)
            // Text: "Log Out", Poltawski Nowy SemiBold 18, Fill: #FA2323
            // ===================================================================
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Text('Keluar dari Akun?'),
                        content: const Text(
                            'Apakah Anda yakin ingin keluar dari akun Xema ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Keluar',
                                style: TextStyle(color: Color(0xFFFA2323))),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 319,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(
                      color: const Color(0xFFCA31FF),
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x85D538F9),
                        blurRadius: 5,
                        offset: Offset(0, 4),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.poltawskiNowy(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFA2323),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow({
    required String iconAsset,
    required double iconWidth,
    required double iconHeight,
    required String title,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(25) : Radius.zero,
        bottom: isLast ? const Radius.circular(25) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ikon Menu Asli Figma dengan warna tepat #52086B
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Image.asset(
                  iconAsset,
                  width: iconWidth,
                  height: iconHeight,
                  fit: BoxFit.contain,
                  color: const Color(0xFF52086B),
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Teks Label Menu (Poltawski Nowy SemiBold (w600) 20px Asli Figma)
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poltawskiNowy(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ),

            // Ikon Panah Kanan Asli Figma (Node 38:167 - Vector arrow) dengan warna #52086B
            SizedBox(
              width: 26,
              height: 26,
              child: Center(
                child: Image.asset(
                  'assets/profile/icon_arrow.png',
                  width: 22,
                  height: 20,
                  fit: BoxFit.contain,
                  color: const Color(0xFF52086B),
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Garis Pemisah Menu Presisi Figma: Line 45, 46, 47 (Stroke #000000 20%)
class _FigmaDivider extends StatelessWidget {
  const _FigmaDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.black.withOpacity(0.20),
    );
  }
}
