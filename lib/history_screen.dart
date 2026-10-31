import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_colors.dart';

/// Screen Riwayat Transaksi (Figma Node-ID: 105-110 Pending & 817-922 Selesai & 1495-1758 Header)
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Default: Tab 1 (Selesai), Tab 0 (Pending)
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header Ungu dengan Motif Gelembung Murni Vektor (Node 1495-1758)
          _buildHeader(context),

          // 2. Konten TabView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Tab 0: Pending (Empty State) - Node 105:110
                _HistoryPendingTab(),

                // Tab 1: Selesai (Grouped List Transaksi) - Node 817:922
                _HistoryCompletedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. HEADER SECTION (FIGMA: NODE 1495-1758)
  // Rectangle elips background asli Figma + Text & TabBar Flutter murni (Tanpa double)
  // ===========================================================================
  Widget _buildHeader(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerHeight = 152.0 + statusBarHeight;

    return Container(
      width: double.infinity,
      height: headerHeight,
      color: const Color(0xFFD373FC),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Latar Belakang Rectangle Asli Motif Elips Gelembung Figma Node 1495-1758 (100% Bersih dari teks/ikon)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/figma_history_bg_clean.png',
              width: double.infinity,
              height: headerHeight,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Bar Judul "Riwayat Transaksi" & Tombol Kalender Asli Figma
          Positioned(
            top: statusBarHeight + 12,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(
                      width: 44), // Balancer agar teks persis di tengah
                  Expanded(
                    child: Text(
                      'Riwayat Transaksi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF54086D),
                      ),
                    ),
                  ),
                  // Tombol Ikon Kalender
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFD373FC),
                                onPrimary: Colors.white,
                                onSurface: AppColors.textDark,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/icons/figma_calendar_clean.png',
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. TabBar "Pending" & "Selesai" Asli Figma dengan garis indikator
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF54086D),
              unselectedLabelColor: const Color(0xFF54086D).withOpacity(0.65),
              indicatorColor: const Color(0xFF54086D),
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.cormorantGaramond(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.cormorantGaramond(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Selesai'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 0: PENDING (EMPTY STATE - FIGMA NODE 1222-1751 / 105:110)
// =============================================================================
class _HistoryPendingTab extends StatelessWidget {
  const _HistoryPendingTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ilustrasi Asli Figma: Tablet Xema Ungu + Smartphone + Koin Emas
            Image.asset(
              'assets/images/empty_pending_illustration.png',
              width: 320,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _buildFallbackIllustration(),
            ),

            const SizedBox(height: 24),

            // Judul Empty State
            Text(
              'Semua transaksi sudah beres!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF261033),
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle Deskripsi Sesuai Figma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Setiap transaksi yang masih dalam proses akan muncul di halaman ini',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF8E8E93),
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIllustration() {
    return SizedBox(
      width: 180,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8E7FF).withValues(alpha: 0.7),
            ),
          ),
          const Icon(
            Icons.receipt_long_rounded,
            color: AppColors.headerPurple,
            size: 64,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 1: SELESAI (LIST TRANSAKSI PER BULAN - FIGMA NODE 817:922 & 817:981)
// =============================================================================
class _HistoryCompletedTab extends StatelessWidget {
  const _HistoryCompletedTab();

  @override
  Widget build(BuildContext context) {
    // Data dummy transaksi presisi 100% sesuai Figma (Riwayat Transaksi 2)
    final groups = [
      {
        'month': 'Oktober 2026',
        'items': [
          {
            'status': 'Dana Keluar',
            'title': 'Pembayaran e-Wallet\nBerhasil ke JENNY ROSA',
            'date': '5 Okt 2026, 21:00',
            'amount': '-Rp 50.000',
            'isIncome': false,
          },
          {
            'status': 'Dana Masuk',
            'title': 'Menerima saldo dari BSI\nZAVELLA MEICA',
            'date': '1 Okt 2026, 13:21',
            'amount': '+Rp 100.000',
            'isIncome': true,
          },
        ],
      },
      {
        'month': 'Agustus 2026',
        'items': [
          {
            'status': 'Dana Masuk',
            'title': 'Menerima saldo dari BRI\nAISHA PUTRI',
            'date': '23 Agu 2026, 18:06',
            'amount': '+Rp 100.000',
            'isIncome': true,
          },
        ],
      },
      {
        'month': 'Mei 2026',
        'items': [
          {
            'status': 'Dana Masuk',
            'title': 'Menerima saldo dari\nSEABANK QUEEN VICTORY',
            'date': '27 Mei 2026, 22:24',
            'amount': '+Rp 100.000',
            'isIncome': true,
          },
        ],
      },
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final month = group['month'] as String;
        final items = group['items'] as List<Map<String, dynamic>>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bulan Sesuai Figma: Roboto Slab Bold 16, #000000
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 8, top: 4),
              child: Text(
                month,
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0,
                ),
              ),
            ),

            // Daftar Kartu Transaksi Sesuai Node 817-981
            ...items.map((item) => _TransactionCard(item: item)),

            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}

// =============================================================================
// KARTU TRANSAKSI (FIGMA NODE 817:981 / GROUP 224 / RECTANGLE 50)
// Dimensi Figma: W: 354, H: 114, Corner Radius: 15
// Fill: #F3D8FF 100% Opacity (Exact dari inspect figma: Rectangle 50)
// Stroke: #000000 20% Opacity, Weight: 1 (Inside)
// Drop Shadow: Blur 4, Y: 4, Color: black 25%
// =============================================================================
class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _TransactionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final String status = item['status'] as String;
    final String title = item['title'] as String;
    final String date = item['date'] as String;
    final String amount = item['amount'] as String;

    return Container(
      width: double.infinity,
      height: 114, // Exact Figma height: 114px
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D8FF), // Exact Figma Fill: #F3D8FF 100%
        borderRadius: BorderRadius.circular(15), // Corner radius: 15
        border: Border.all(
          color: const Color(0xFF000000)
              .withValues(alpha: 0.20), // Stroke: #000000 20% weight 1
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 4), // Drop shadow dari Figma
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Baris Atas: Status Transaksi ("Dana Keluar" / "Dana Masuk") & Nominal (+Rp / -Rp)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status Transaksi (Figma: Roboto Slab Bold 17.5, #000000)
              Text(
                status,
                style: GoogleFonts.robotoSlab(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF000000),
                  letterSpacing: 0,
                  height: 1.0,
                ),
              ),

              // Nominal Transaksi (Figma: Roboto Slab Bold 17, #000000)
              Text(
                amount,
                style: GoogleFonts.robotoSlab(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF000000),
                  letterSpacing: 0,
                  height: 1.0,
                ),
              ),
            ],
          ),

          // Judul Detail Transaksi (Figma: Poppins Medium-Bold 13.5, #000000, line height 1.25)
          Text(
            title,
            maxLines: 2,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
              height: 1.25,
            ),
          ),

          // Tanggal & Jam (Figma: Poppins Regular 11.5, #757575)
          Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
