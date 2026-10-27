import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _currentIndex = 1; // 1 = Tab HISTORY aktif

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 Tab: Pending & Selesai
      initialIndex: 1, // Default buka tab Selesai
      child: Scaffold(
        backgroundColor: Colors.white,

        // ==========================================
        // 1. APPBAR UNGU & TAB BAR (RESMI & AMAN)
        // ==========================================
        appBar: AppBar(
          backgroundColor: const Color(0xFFC040FB), // Warna ungu khas Xema
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Riwayat Transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
              onPressed: () {
                // Aksi kalender
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),

        // ==========================================
        // 2. ISI HALAMAN (TAB BAR VIEW)
        // ==========================================
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: TabBarView(
              children: [
                _buildPendingTab(),
                _buildSelesaiTab(),
              ],
            ),
          ),
        ),

        // ==========================================
        // 3. BOTTOM NAVIGATION BAR (MENU BAWAH)
        // ==========================================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFC040FB),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'HISTORY',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'INBOX',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'USER',
            ),
          ],
        ),
      ),
    );
  }

  // TAB PENDING (KOSONG)
  Widget _buildPendingTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 70,
                color: Color(0xFFC040FB),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Semua transaksi sudah beres!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Setiap transaksi yang masih dalam proses akan muncul di halaman ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB SELESAI (DAFTAR TRANSAKSI)
  Widget _buildSelesaiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMonthHeader('Oktober 2026'),
        _buildTransactionCard(
          title: 'Dana Keluar',
          subtitle: 'Pembayaran e-Wallet\nBerhasil ke JENNY ROSA',
          date: '10 Okt 2026, 12:40',
          amount: '-Rp 50.000',
          isIncome: false,
        ),
        _buildTransactionCard(
          title: 'Dana Masuk',
          subtitle: 'Menerima saldo dari BRI\nSAYELLA MEIDA',
          date: '7 Okt 2026, 10:11',
          amount: '+Rp 100.000',
          isIncome: true,
        ),
        const SizedBox(height: 12),
        _buildMonthHeader('Agustus 2026'),
        _buildTransactionCard(
          title: 'Dana Masuk',
          subtitle: 'Menerima saldo dari BSI\nAISYAH FITRI',
          date: '28 Agt 2026, 15:14',
          amount: '+Rp 100.000',
          isIncome: true,
        ),
        const SizedBox(height: 12),
        _buildMonthHeader('Mei 2026'),
        _buildTransactionCard(
          title: 'Dana Masuk',
          subtitle: 'Menerima saldo dari\nSEABANK QUEEN VICTORY',
          date: '27 Mei 2026, 12:14',
          amount: '+Rp 100.000',
          isIncome: true,
        ),
      ],
    );
  }

  Widget _buildMonthHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String date,
    required String amount,
    required bool isIncome,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8D4FF),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF2E7D32) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
