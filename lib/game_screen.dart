import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _selectedGame = 'Mobile Legends';
  String _selectedPackage = '50 Diamonds';
  String _price = 'Rp 14.000';
  final TextEditingController _userIdController = TextEditingController(text: '12345678');
  final TextEditingController _zoneIdController = TextEditingController(text: '2001');

  final List<Map<String, dynamic>> _games = [
    {'name': 'Mobile Legends', 'icon': Icons.flash_on},
    {'name': 'Free Fire', 'icon': Icons.local_fire_department},
    {'name': 'PUBG Mobile', 'icon': Icons.military_tech},
    {'name': 'Roblox', 'icon': Icons.token},
  ];

  final List<Map<String, String>> _packages = [
    {'item': '5 Diamonds', 'price': 'Rp 1.000'},
    {'item': '20 Diamonds', 'price': 'Rp 5.500'},
    {'item': '50 Diamonds', 'price': 'Rp 14.000'},
    {'item': '100 Diamonds', 'price': 'Rp 28.000'},
    {'item': '250 Diamonds', 'price': 'Rp 70.000'},
    {'item': '500 Diamonds', 'price': 'Rp 140.000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Top Up Game',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilihan Game
            Text('Pilih Game', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF570374))),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _games.length,
                itemBuilder: (context, index) {
                  final g = _games[index];
                  final isSelected = _selectedGame == g['name'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGame = g['name']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(g['icon'] as IconData, size: 18, color: isSelected ? Colors.white : const Color(0xFF570374)),
                          const SizedBox(width: 6),
                          Text(
                            g['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF570374),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Form User ID & Zone ID
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FB),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF3D8FF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Akun Game',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Silakan masukkan User ID dan Zone ID Anda (Contoh: 12345678 (2001)).',
                    style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF939393)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _userIdController,
                          style: GoogleFonts.robotoSlab(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'User ID',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _zoneIdController,
                          style: GoogleFonts.robotoSlab(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Zone ID',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('Pilih Item / Nominal', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF570374))),
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
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final p = _packages[index];
                final isSelected = _selectedPackage == p['item'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPackage = p['item']!;
                      _price = p['price']!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF3D8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                          p['item']!,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823)),
                        ),
                        Text(
                          p['price']!,
                          style: GoogleFonts.robotoSlab(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFCA31FF)),
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        title: Text('Top Up Berhasil!', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF570374))),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Game: $_selectedGame'),
                            Text('Akun: ${_userIdController.text} (${_zoneIdController.text})'),
                            Text('Item: $_selectedPackage'),
                            Text('Total Bayar: $_price', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA31FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: Text('Beli $_selectedPackage ($_price)', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

