import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF570374),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF570374)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFCA31FF),
          unselectedLabelColor: const Color(0xFF939393),
          indicatorColor: const Color(0xFFCA31FF),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Belum Dibaca'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllTab(),
          _buildUnreadTab(),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildNotifCard(
          title: 'Gratis 7x Biaya Admin!',
          content: 'Setor & Tarik pakai Xema bisa langsung di Indomaret & Alfamart terdekatmu, gratis 7x biaya admin! S&K berlaku.',
          time: '30 Sep 2026, 12:04',
          isNew: true,
        ),
        _buildNotifCard(
          title: 'Top Up E-Wallet Berhasil',
          content: 'Transaksi pengisian saldo ke akun DANA JENNY ROSA sebesar Rp 50.000 telah sukses diproses.',
          time: '5 Okt 2026, 21:00',
          isNew: false,
        ),
        _buildNotifCard(
          title: 'Keamanan Akun: PIN Diperbarui',
          content: 'PIN transaksi Anda berhasil diatur. Jangan berikan kode PIN kepada siapa pun demi keamanan akun.',
          time: '28 Sep 2026, 09:30',
          isNew: false,
        ),
      ],
    );
  }

  Widget _buildUnreadTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_inbox.png',
              width: 180,
              height: 180,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: Color(0xFFCA31FF),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Belum Ada Pesan Baru',
              style: GoogleFonts.robotoSlab(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C0823),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nantikan promo terbaru disini ya. Sekarang, lanjut bayar & transaksi di Xema, yuk!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF939393),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifCard({
    required String title,
    required String content,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFFF8F0FC) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isNew ? const Color(0xFFCA31FF) : const Color(0xFFE0E0E0),
          width: isNew ? 1.2 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF570374),
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCA31FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Baru',
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF1C0823), height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF939393)),
          ),
        ],
      ),
    );
  }
}
