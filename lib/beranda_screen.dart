import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_colors.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';
import 'ppob_screen.dart';
import 'gold_screen.dart';
import 'game_screen.dart';
import 'koin_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _currentTabIndex = 0;
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FB),
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const HistoryScreen();
      case 2:
        return const KoinScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ==================== HEADER UNGU FIGMA ====================
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 65),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCA31FF), Color(0xFF9B1DC7), Color(0xFF772096)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    // Top User Bar
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFE9CAF7),
                            child: Icon(Icons.person, color: AppColors.primary, size: 26),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, LISA ARUNIA',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '0851 2343 5656',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: const Color(0xFFF3D8FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notifikasi Bell
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Stack(
                              children: [
                                Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Color(0xFFFF383C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==================== KARTU SALDO OVERLAPPING ====================
              Positioned(
                left: 18,
                right: 18,
                bottom: -45,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF772096).withValues(alpha: 0.18),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Saldo Xema',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF939393),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBalanceVisible = !_isBalanceVisible;
                                      });
                                    },
                                    child: Icon(
                                      _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                                      size: 16,
                                      color: const Color(0xFF939393),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isBalanceVisible ? 'Rp 76.565.000' : 'Rp ••••••••',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF570374),
                                ),
                              ),
                            ],
                          ),
                          // Badge XEMA POIN
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const KoinScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3D8FF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFCA31FF), width: 0.8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/coin_gold.png',
                                    width: 18,
                                    height: 18,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.monetization_on,
                                      color: Color(0xFFE5A93C),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '1.500 Poin',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF570374),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // ==================== GRID MENU LAYANAN UTAMA FIGMA ====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan Xema',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF570374),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 10,
                    children: [
                      _buildMenuItem(
                        icon: Icons.send_rounded,
                        label: 'Transfer',
                        color: const Color(0xFFCA31FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransferScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.add_circle_outline,
                        label: 'Isi Saldo',
                        color: const Color(0xFF1976D2),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TopUpScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.phone_android_rounded,
                        label: 'Pulsa & Kuota',
                        color: const Color(0xFFE91E63),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.bolt_rounded,
                        label: 'PLN',
                        color: const Color(0xFFFF9800),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 1)),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'E-Wallet',
                        color: const Color(0xFF00B0FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransferScreen(isEwallet: true)),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.diamond_outlined,
                        label: 'Emas',
                        color: const Color(0xFFFFC107),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GoldScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.sports_esports_outlined,
                        label: 'Game',
                        color: const Color(0xFF9C27B0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GameScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.stars_rounded,
                        label: 'Poin',
                        color: const Color(0xFFCA31FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KoinScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ==================== BANNER PROMO RESMI FIGMA ====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promo & Informasi',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF570374),
                      ),
                    ),
                    Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCA31FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 135,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Banner 1: Koin Promo
                      _buildPromoCard(
                        title: 'KUMPULKAN LEBIH BANYAK POIN!',
                        subtitle: 'Tukar poin ke uang tunai hingga Rp 100.000',
                        badgeText: 'XEMA POIN',
                        color1: const Color(0xFF772096),
                        color2: const Color(0xFFB952DD),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KoinScreen()),
                        ),
                      ),
                      // Banner 2: Pulsa Promo
                      _buildPromoCard(
                        title: 'Diskon Pulsa s/d 20%!',
                        subtitle: 'Spesial transaksi isi ulang paket data Telkomsel & Indosat',
                        badgeText: 'HEMAT',
                        color1: const Color(0xFF52086B),
                        color2: const Color(0xFFCA31FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                        ),
                      ),
                      // Banner 3: Emas Promo
                      _buildPromoCard(
                        title: 'Investasi Emas Bebas Admin',
                        subtitle: 'Mulai dari Rp 10.000, gratis biaya admin 5x sebulan',
                        badgeText: 'INVESTASI',
                        color1: const Color(0xFF490461),
                        color2: const Color(0xFFE5A93C),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GoldScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C0823),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 270,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color1.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFCA31FF),
        unselectedItemColor: const Color(0xFF939393),
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Xema Poin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
