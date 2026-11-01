import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen Notifikasi (Figma Node-ID: 76-49 Notifikasi 1 & 146-259 Notifikasi 2)
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Header Putih Bermotif Balon / Lingkaran Ungu Vektor (Node 1489-1757)
            _buildFigmaHeader(context),

            // 2. TabBar Interaktif (Amplop Hitam Besar + Label)
            _buildTabBar(),

            // 3. Konten TabView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // Tab 1: Semua (List 3 Notifikasi Asli Figma - Node 76-49)
                  _AllNotificationsTab(),

                  // Tab 2: Belum Dibaca (Empty State Kucing - Node 146-259)
                  _UnreadEmptyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. HEADER SECTION (FIGMA: Node 1489-1757)
  // Background putih bersih dengan bentuk elips ungu muda presisi 100% dari Figma
  // ===========================================================================
  Widget _buildFigmaHeader(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerHeight = 135.0 + statusBarHeight;

    return Container(
      width: double.infinity,
      height: headerHeight,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gambar Header Asli Figma (Posisi, Ukuran, Bentuk Elips 100% Identik)
          Positioned(
            top: statusBarHeight - 10,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/figma_rectangle_header_bg.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),

          // Garis horizontal pembatas bawah header (Figma stroke: 1px hitam 20%)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1.0,
              color: Colors.black.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. TABBAR SECTION (Amplop Hitam Figma + Label "Semua" & "Belum Dibaca")
  // ===========================================================================
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF570374), // Ungu tua aktif Figma
            unselectedLabelColor: const Color(0xFF000000), // Hitam pekat Figma
            indicatorColor: const Color(0xFF570374),
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 24),
            labelStyle: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF570374),
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              letterSpacing: 0.2,
            ),
            tabs: [
              Tab(
                icon: Container(
                  width: 38,
                  height: 25,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(20, 11),
                      painter: _MailVFlapPainter(),
                    ),
                  ),
                ),
                text: 'Semua',
                iconMargin: const EdgeInsets.only(bottom: 2),
              ),
              Tab(
                icon: Container(
                  width: 38,
                  height: 25,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(20, 11),
                      painter: _MailVFlapPainter(),
                    ),
                  ),
                ),
                text: 'Belum Dibaca',
                iconMargin: const EdgeInsets.only(bottom: 2),
              ),
            ],
          ),
          Container(
            height: 1.0,
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk V-Flap Amplop Hitam Figma
class _MailVFlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// TAB 1: SEMUA NOTIFIKASI (FIGMA NODE 76-49)
// Tiga Kartu Notifikasi Asli Figma dengan Ukuran Besar & Proporsional
// =============================================================================
class _AllNotificationsTab extends StatelessWidget {
  const _AllNotificationsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: const [
        // Kartu 1: Tagihan Kartu Kredit
        _FigmaNotifItemCard(
          icon: Icons.receipt_long_rounded,
          title: 'Waktunya Bayar Tagihan?',
          description:
              'Daripada telat, langsung bayar tagihan\nKartu Kredit kamu di Xema. Simpel\ndan gak pakai lama~',
          dateTime: '5 Okt 2026, 15:07',
        ),

        // Kartu 2: Setor & Tarik di Indomaret & Alfamart
        _FigmaNotifItemCard(
          icon: Icons.local_offer_rounded,
          title: 'Simpel Ajaaa~',
          description:
              'Setor & Tarik pakai Xema bisa langsung\ndi Indomaret & Alfamart terdekatmu,\ngratis 7x biaya admin!\nS&K berlaku',
          dateTime: '30 Sep 2026, 12:04',
        ),

        // Kartu 3: Email Belum Terverifikasi
        _FigmaNotifItemCard(
          icon: Icons.verified_user_rounded,
          title: 'Email Kamu Belum Terverifikasi !',
          description:
              'Saat ini, kamu tidak bisa menerima\ninformasi Xema melalui email. Segera\nlakukan verifikasi email untuk bisa\nmenerima informasi penting seperti e-\nstatement bulanan, transaksi & promosi',
          dateTime: '8 Agu 2026, 12:04',
        ),
      ],
    );
  }
}

// =============================================================================
// KARTU NOTIFIKASI FIGMA (Putih Solid, Border Tipis Hitam 35%, Shadow, Radius 15)
// =============================================================================
class _FigmaNotifItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String dateTime;

  const _FigmaNotifItemCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // Corner radius: 15
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.35), // Border tegas Figma
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Ikon kotak kecil + Judul Tebal Hitam Pekat
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DEFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: const Color(0xFF570374),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700, // Tebal pekat sesuai Figma
                    color: const Color(0xFF000000), // Hitam pekat #000000
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Deskripsi Notifikasi Tebal & Hitam Pekat Sesuai Figma
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600, // Tebal medium-bold sesuai Figma
              color: const Color(0xFF111111), // Hitam pekat tegas
              height: 1.35,
            ),
          ),

          const SizedBox(height: 8),

          // Tanggal & Jam di Kiri Bawah
          Text(
            dateTime,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w500, // Semi tebal abu-abu tegas
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 2: EMPTY STATE NOTIFIKASI 2 (FIGMA NODE 146-259)
// Ilustrasi Kucing Besar HD + Balon Chat Ungu + Kotak Surat Asli Figma
// =============================================================================
class _UnreadEmptyTab extends StatelessWidget {
  const _UnreadEmptyTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ilustrasi Kucing Asli HD Figma (Ukuran Besar W: 330, H: 260)
            Image.asset(
              'assets/images/empty_inbox_cat_hd.png',
              width: 330,
              height: 260,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/empty_inbox_cat.png',
                width: 300,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 18),

            // Judul Utama: "Belum Ada Pesan" (Figma: Roboto Slab Bold 17, #000000)
            Text(
              'Belum Ada Pesan',
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoSlab(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000), // Hitam pekat tegas
              ),
            ),

            const SizedBox(height: 8),

            // Deskripsi Subtitle: (Figma: Roboto Slab / Serif Regular 13.5, #000000)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Nantikan promo terbaru disini ya. Sekarang,\nlanjut bayar & transaksi di Xema, yuk!',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSlab(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color:
                      const Color(0xFF000000), // Hitam tegas tebal sesuai Figma
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
