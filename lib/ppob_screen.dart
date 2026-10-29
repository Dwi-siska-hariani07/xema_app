import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PpobScreen extends StatefulWidget {
  final int initialTab; // 0: Pulsa/Kuota, 1: PLN
  const PpobScreen({super.key, this.initialTab = 0});

  @override
  State<PpobScreen> createState() => _PpobScreenState();
}

class _PpobScreenState extends State<PpobScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _phoneController = TextEditingController(text: '0851 2343 5656');
  final TextEditingController _meterController = TextEditingController(text: '1423 5678 9012');

  String _selectedPulsa = '50.000';
  String _selectedPln = '100.000';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
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
          'Pembayaran Tagihan',
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
            Tab(text: 'Pulsa & Kuota'),
            Tab(text: 'Listrik PLN'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPulsaTab(),
          _buildPlnTab(),
        ],
      ),
    );
  }

  // TAB 1: PULSA & KUOTA
  Widget _buildPulsaTab() {
    final List<Map<String, String>> pulsaOptions = [
      {'nominal': '15.000', 'price': '15.500'},
      {'nominal': '25.000', 'price': '25.500'},
      {'nominal': '50.000', 'price': '50.000'},
      {'nominal': '100.000', 'price': '99.000'},
      {'nominal': '200.000', 'price': '198.000'},
      {'nominal': '500.000', 'price': '495.000'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Handphone',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.robotoSlab(fontSize: 16),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.contact_phone_outlined, color: Color(0xFFCA31FF)),
              filled: true,
              fillColor: const Color(0xFFF3D8FF),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Denominasi Pulsa',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: pulsaOptions.length,
            itemBuilder: (context, index) {
              final item = pulsaOptions[index];
              final isSelected = _selectedPulsa == item['nominal'];
              return GestureDetector(
                onTap: () => setState(() => _selectedPulsa = item['nominal']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF3D8FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFFE0E0E0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pulsa ${item['nominal']}',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823)),
                      ),
                      Text(
                        'Rp ${item['price']}',
                        style: GoogleFonts.robotoSlab(fontSize: 12, color: const Color(0xFFCA31FF), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _showSuccessDialog('Pulsa Rp $_selectedPulsa ke ${_phoneController.text}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Beli Sekarang',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: LISTRIK PLN
  Widget _buildPlnTab() {
    final List<String> plnTokens = ['20.000', '50.000', '100.000', '200.000', '500.000', '1.000.000'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Meter / ID Pelanggan PLN',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _meterController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.robotoSlab(fontSize: 16),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.bolt, color: Color(0xFFCA31FF)),
              filled: true,
              fillColor: const Color(0xFFF3D8FF),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Nama Pelanggan: LISA ARUNIA (R1M / 900 VA)',
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Nominal Token Listrik',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: plnTokens.length,
            itemBuilder: (context, index) {
              final token = plnTokens[index];
              final isSelected = _selectedPln == token;
              return GestureDetector(
                onTap: () => setState(() => _selectedPln = token),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF3D8FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFFE0E0E0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Token Rp $token',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823)),
                      ),
                      Text(
                        'Admin Rp 1.500',
                        style: GoogleFonts.robotoSlab(fontSize: 11, color: const Color(0xFF939393)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _showSuccessDialog('Token Listrik PLN Rp $_selectedPln'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52086B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Bayar Tagihan',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String desc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 60),
              const SizedBox(height: 12),
              Text(
                'Pembayaran Berhasil!',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1C0823)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Struk & resi transaksi telah tersimpan di menu Riwayat.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF570374)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA31FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}

