import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_colors.dart';
import 'core/app_text_styles.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';
import 'ppob_screen.dart';
import 'gold_screen.dart';
import 'game_screen.dart';
import 'koin_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';

/// Screen Utama Beranda (Figma Node-ID: 933-2386 Beranda 1 & 834-2649 Beranda 2)
/// Saat muncul beranda pertama saldo terbaca/tertera (Beranda 1), dan jika diklik icon mata saldo tertutup (Beranda 2).
class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _currentTabIndex = 0;
  // Default awal: true (Saldo TERBUKA tertera Rp 76.565.000,00 sesuai Beranda 1)
  // Jika di-klik icon mata: berubah menjadi false (Saldo TERTUTUP bulat-bulat sesuai Beranda 2)
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildCurrentTab(),
      bottomNavigationBar: _CustomBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const HistoryScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // 1. Header Section: Rectangle 1 (#CA31FF), Profil User, Logo xema, dan Saldo
          _HeaderSection(
            isBalanceVisible: _isBalanceVisible,
            onToggleBalance: () {
              setState(() {
                _isBalanceVisible = !_isBalanceVisible;
              });
            },
          ),

          // Gap sesuai posisi Figma Y: 262 - 235 = 27px
          const SizedBox(height: 27),

          // 2. Kotak 8 Menu Layanan (Group 282 / Group 285)
          const _ServicesGridCard(),

          const SizedBox(height: 20),

          // 3. Banner Promo Carousel (Frame 322 / Frame 321)
          const _PromoCarouselSection(),

          const SizedBox(height: 20),

          // 4. Kartu XEMA POIN (Group 284 / Group 292)
          const _XemaPointsSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// =============================================================================
// 1. HEADER SECTION (Rectangle 1, Group 361, Group 295, Group 168, Group 302)
// =============================================================================
class _HeaderSection extends StatelessWidget {
  final bool isBalanceVisible;
  final VoidCallback onToggleBalance;

  const _HeaderSection({
    required this.isBalanceVisible,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 235,
      decoration: const BoxDecoration(
        color: AppColors.headerPurple, // #CA31FF
      ),
      child: Stack(
        children: [
          // Lingkaran Dekorasi Ellipse Latar Belakang (Group 361)
          Positioned(
            top: -30,
            left: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryDome.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Konten Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Atas: Profil Lisa Arunia & Logo xema
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Kapsul Profil Lisa Arunia (Group 295 / Rectangle 7)
                      const _UserProfileBadge(),

                      // Logo xema Kanan Atas (Group 168)
                      Image.asset(
                        'assets/images/xema_header_logo_cropped.png',
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              'xema',
                              style: AppTextStyles.figmaSerif(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Total Saldo (Group 302 & Group 297)
                  _BalanceCard(
                    isVisible: isBalanceVisible,
                    onToggle: onToggleBalance,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kapsul Profil Lisa Arunia (Group 295)
class _UserProfileBadge extends StatelessWidget {
  const _UserProfileBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.profileBadgeBg.withValues(alpha: 0.60), // #8F46AB 60%
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: AppColors.profileBadgeBg,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LISA ARUNIA',
                  style: AppTextStyles.figmaSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bottomNavBg,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '0851 2343 5656',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.bottomNavBg,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Area Total Saldo (Group 302 & Group 297)
class _BalanceCard extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  const _BalanceCard({
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Total Saldo & Ikon Mata (akar-icons:eye-closed)
        Row(
          children: [
            Text(
              'Total Saldo',
              style: AppTextStyles.figmaSerif(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: isVisible
                  ? const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 18,
                    )
                  : CustomPaint(
                      size: const Size(18, 10),
                      painter: _FigmaEyeClosedPainter(),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Rectangle 3: Kapsul Nilai Saldo (W: 229, H: 33, R: 25, Fill #D9D9D9 20%)
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: Container(
            height: 33,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rp',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                isVisible
                    ? Text(
                        '76.565.000,00',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                          height: 1.0,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          8,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 2. KOTAK 8 MENU LAYANAN (Group 282 / Group 285)
// =============================================================================
class _ServicesGridCard extends StatelessWidget {
  const _ServicesGridCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.cardPurpleBottom, // #851FAB Base layer
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 4,
              right: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardPurpleTop, // #CB81F1 Top layer
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Baris 1: TRANSFER, ISI SALDO, PULSA & KUOTA, PLN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ServiceMenuItem(
                          iconWidget: const Icon(Icons.near_me_outlined,
                              color: AppColors.primaryDeep, size: 26),
                          label: 'TRANSFER',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TransferScreen()),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: const Icon(Icons.add_box_outlined,
                              color: AppColors.primaryDeep, size: 26),
                          label: 'ISI SALDO',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TopUpScreen()),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: const Icon(Icons.phonelink_ring_outlined,
                              color: AppColors.primaryDeep, size: 25),
                          label: 'PULSA & KUOTA',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const PpobScreen(initialTab: 0)),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: _buildPlnIcon(),
                          label: 'PLN',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const PpobScreen(initialTab: 1)),
                          ),
                        ),
                      ],
                    ),

                    // Baris 2: E-WALLET, INVESTASI EMAS, TOP UP GAME, MENU
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ServiceMenuItem(
                          iconWidget: _buildEwalletIcon(),
                          label: 'E-WALLET',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const TransferScreen(isEwallet: true)),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: _buildInvestasiEmasIcon(),
                          label: 'INVESTASI\nEMAS',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const GoldScreen()),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: const Icon(Icons.sports_esports_outlined,
                              color: AppColors.primaryDeep, size: 26),
                          label: 'TOP UP GAME',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const GameScreen()),
                          ),
                        ),
                        _ServiceMenuItem(
                          iconWidget: _buildMenuIcon(),
                          label: 'MENU',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PpobScreen()),
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
      ),
    );
  }

  static Widget _buildPlnIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.plnYellow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.flash_on_rounded,
              color: AppColors.accentRed, size: 24),
          Positioned(
            bottom: 6,
            child: Container(
              width: 14,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFF0091EA),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEwalletIcon() {
    return Container(
      width: 28,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF6A008A),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 7,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInvestasiEmasIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 6,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.goldBarColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Container(
          width: 6,
          height: 17,
          decoration: BoxDecoration(
            color: AppColors.goldBarColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.goldBarColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  static Widget _buildMenuIcon() {
    const Color dotColor = Color(0xFF9C27B0);
    return SizedBox(
      width: 22,
      height: 22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 9.5,
                height: 9.5,
                decoration: const BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 9.5,
                height: 9.5,
                decoration: BoxDecoration(
                  color: dotColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 9.5,
                height: 9.5,
                decoration: BoxDecoration(
                  color: dotColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                width: 9.5,
                height: 9.5,
                decoration: const BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tombol Satuan Menu Layanan
class _ServiceMenuItem extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const _ServiceMenuItem({
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.figmaSerif(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
                letterSpacing: 0.1,
                height: 1.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 3. BANNER PROMO CAROUSEL (Frame 322 / Frame 321: H = 111.79)
// =============================================================================
class _PromoCarouselSection extends StatelessWidget {
  const _PromoCarouselSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          // Banner 1: Diskon Pulsa (Kuning #FFD500 dengan 3D Bevel)
          Container(
            width: 325,
            margin: const EdgeInsets.only(right: 14, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.promoYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.promoYellowShadow,
                  blurRadius: 0,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Promo!!',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Diskon Pulsa s/d 20%!!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: 0.15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '20%',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.promoYellow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Banner 2: Bebas Biaya Admin (Biru #29B6F6)
          Container(
            width: 325,
            margin: const EdgeInsets.only(right: 14, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.promoBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.promoBlueShadow,
                  blurRadius: 0,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Promo!!',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bebas Biaya Admin Transfer!!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.celebration_rounded,
                    color: Colors.white, size: 34),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. KARTU XEMA POIN (Group 284 / Group 292)
// Figma:
//   - Rectangle 41 (Base layer ungu tua): W: 320.42, H: 107.85, Fill: #A242C4, Radius: 18
//   - Rectangle 38 (Top layer putih): W: 312.69, H: 100.86, Fill: #FFFFFF, Radius: 18, Drop Shadow
//   - Koin emas: X: 42, Y: 640
//   - Text "XEMA POIN: 1.500!" & "TUKAR HADIAH!!": Font Serif (Puchavsk / Playfair / Cormorant)
// =============================================================================
class _XemaPointsSection extends StatelessWidget {
  const _XemaPointsSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KoinScreen()),
          );
        },
        child: SizedBox(
          width: 322,
          height: 110,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Lapisan Bawah (Rectangle 41 - #A242C4, Radius: 18)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 320.42,
                  height: 107.85,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA242C4), // Fill Figma: #A242C4
                    borderRadius:
                        BorderRadius.circular(18), // Corner radius: 18
                  ),
                ),
              ),

              // Lapisan Atas (Rectangle 38 - #FFFFFF, Radius: 18, Shadow)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 312.69,
                  height: 100.86,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white, // Fill Figma: #FFFFFF
                    borderRadius:
                        BorderRadius.circular(18), // Corner radius: 18
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ilustrasi Koin Emas Figma
                      Image.asset(
                        'assets/images/coin_gold.png',
                        width: 58,
                        height: 58,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.monetization_on_rounded,
                          color: Color(0xFFFFB300),
                          size: 50,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Teks "XEMA POIN: 1.500!" dan "TUKAR HADIAH!!" (Font Serif Puchavsk / Cormorant Garamond)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'XEMA POIN: 1.500!',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                                letterSpacing: 0.2,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'TUKAR HADIAH!!',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color(0xFF9B1DC7), // Figma: #9B1DC7
                                letterSpacing: 0.2,
                                height: 1.1,
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
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 5. CUSTOM BOTTOM NAVIGATION BAR (Group 304 / Rectangle 9: #F3DEFF)
// Figma: Rectangle 9, X: -4, Y: 771, W: 398, H: 85, Fill: #F3D8FF 100%
// Group 287 (HOME): X: 35, Y: 782, W: 46, H: 59
// Frame (#famicons:home): W: 44, H: 44
// Text (HOME): W: 43, H: 16, Font Puchavsk / Serif 14
// =============================================================================
class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3D8FF), // Exact Figma Rectangle 9 Fill: #F3D8FF
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BottomNavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                customAsset: 'assets/icons/home_nav_icon.png',
                label: 'HOME',
                onTap: onTap,
              ),
              _BottomNavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.assignment_outlined,
                customAsset: 'assets/icons/history_nav_icon.png',
                label: 'HISTORY',
                onTap: onTap,
              ),
              _BottomNavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.notifications_none_rounded,
                customAsset: 'assets/icons/inbox_nav_icon.png',
                label: 'INBOX',
                onTap: onTap,
              ),
              _BottomNavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person_outline,
                customAsset: 'assets/icons/user_nav_icon.png',
                label: 'USER',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String? customAsset;
  final String label;
  final ValueChanged<int> onTap;

  const _BottomNavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    this.customAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;
    const Color activeColor =
        Color(0xFF52086B); // Exact Figma nav icon fill: #52086B

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ikon (Figma: W: 44, H: 44)
          SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: customAsset != null
                  ? Image.asset(
                      customAsset!,
                      width: 34,
                      height: 34,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        icon,
                        size: 34,
                        color: isSelected
                            ? activeColor
                            : activeColor.withValues(alpha: 0.70),
                      ),
                    )
                  : Icon(
                      icon,
                      size: 32,
                      color: isSelected
                          ? activeColor
                          : activeColor.withValues(alpha: 0.70),
                    ),
            ),
          ),
          const SizedBox(height: 2),
          // Teks Label 1 baris tidak terpotong (Figma: Typography Puchavsk / Serif Regular 14, #52086B, H: 16)
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              color: isSelected
                  ? activeColor
                  : activeColor.withValues(alpha: 0.70),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CUSTOM PAINTER: Ikon Mata Tertutup Figma (akar-icons:eye-closed)
// =============================================================================
class _FigmaEyeClosedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.85,
      size.width,
      size.height * 0.3,
    );
    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.95),
      paint..strokeWidth = 1.6,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.75),
      Offset(size.width * 0.5, size.height * 1.05),
      paint..strokeWidth = 1.6,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.65),
      Offset(size.width * 0.8, size.height * 0.95),
      paint..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
