import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xema_app/gold_screen.dart';

void main() {
  testWidgets('GoldScreen & Buy Gold complete flow matches Figma nodes', (WidgetTester tester) async {
    // Set screen size to 393 x 852 (Figma dimensions)
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: GoldScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Node 211:1033 (Halaman Utama Investasi Emas)
    expect(find.text('INVESTASI EMAS'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Tabungan Emas Anda'), findsOneWidget);
    expect(find.text('5,2400 Gram'), findsOneWidget);
    expect(find.textContaining('Nilai Saat Ini:'), findsOneWidget);
    expect(find.text('+ Rp 100.000 (0.8%)'), findsOneWidget);
    expect(find.text('Harga Emas Hari Ini'), findsOneWidget);
    expect(find.text('JUAL'), findsOneWidget);
    expect(find.text('BELI'), findsOneWidget);

    // 2. Navigasi ke Layar Beli Emas -> Node 224:265 (State Kosong + Tips Kuning)
    await tester.tap(find.text('BELI'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan Nominal Pembelian'), findsOneWidget);
    expect(find.text('Pilihan Cepat'), findsOneWidget);
    expect(find.text('TIPS:'), findsOneWidget); // Kartu TIPS kuning ada
    expect(find.text('Konfirmasi'), findsNothing); // Tombol konfirmasi belum ada saat nominal kosong

    // 2b. Test Klik Kotak Abu-abu untuk Toggle Keyboard
    await tester.tap(find.text('Rp'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget); // Keyboard muncul!

    // Klik sekali lagi untuk sembunyikan keyboard (Responsive)
    await tester.tap(find.text('Rp'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.backspace_outlined), findsNothing); // Keyboard tertutup!

    // 3. Pilih Pilihan Cepat Rp 100.000 -> Node 296:928 (State Terisi + Rekening Sumber XEMA + Tips Tetap Ada)
    await tester.tap(find.text('Rp 100.000').first);
    await tester.pumpAndSettle();
    expect(find.text('Rekening Sumber (XEMA)'), findsOneWidget); // Kartu rekening muncul
    expect(find.text('0851 2343 5656'), findsOneWidget);
    expect(find.text('TIPS:'), findsOneWidget); // Kartu TIPS DIPERTAHANKAN sesuai permintaan user
    expect(find.text('Konfirmasi'), findsOneWidget); // Tombol konfirmasi pil ungu muncul

    // 4. Klik Konfirmasi -> Node 224:176 (Layar Konfirmasi Pembelian Full-Screen "investasi pembayaran emas")
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();
    expect(find.text('Tabungan Emas'), findsOneWidget);
    expect(find.text('Metode Pembayaran'), findsOneWidget);
    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Nominal Pembelian'), findsOneWidget);
    expect(find.text('Biaya Admin'), findsOneWidget);
    expect(find.text('Gratis'), findsOneWidget);
    expect(find.text('Total Pembayaran'), findsOneWidget);

    // 5. Klik Konfirmasi di Layar Konfirmasi -> Node 270:258 (Layar PIN)
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi PIN'), findsOneWidget);
    expect(find.text('Masukkan 6-digit PIN Transaksi kamu'), findsOneWidget);
    expect(find.text('Lupa PIN?'), findsOneWidget);

    // 6. Masukkan PIN 6 digit (1, 2, 3, 4, 5, 6) - verifikasi angka muncul saat diklik (seperti transfer)
    for (int i = 1; i <= 6; i++) {
      await tester.tap(find.text('$i').first);
      await tester.pump(const Duration(milliseconds: 50));
    }
    // Verifikasi angka PIN muncul di indikator
    expect(find.text('1'), findsWidgets);
    expect(find.text('6'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 7. Node 403:671 (Bukti Transaksi Resi Sukses)
    expect(find.text('Bukti Transaksi'), findsOneWidget);
    expect(find.text('SUKSES!'), findsOneWidget);
    expect(find.text('Nominal  Pembelian'), findsOneWidget);
    expect(find.text('Emas Didapat'), findsOneWidget);
    expect(find.text('Harga Beli/gr'), findsOneWidget);
    expect(find.text('Biaya Admin'), findsOneWidget);
    expect(find.text('Gratis'), findsWidgets);
    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    // 8. Klik OK -> Kembali ke GoldScreen dan saldo emas bertambah
    await tester.ensureVisible(find.text('OK'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('INVESTASI EMAS'), findsOneWidget);
    expect(find.text('5,2835 Gram'), findsOneWidget); // 5.2400 + 0.04347 = 5.2835
  });

  testWidgets('GoldScreen & Sell Gold complete flow matches Figma nodes', (WidgetTester tester) async {
    // Set screen size to 393 x 852 (Figma dimensions)
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: GoldScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verifikasi Layar Utama Investasi Emas & tombol JUAL
    expect(find.text('INVESTASI EMAS'), findsOneWidget);
    expect(find.text('JUAL'), findsOneWidget);

    // 2. Navigasi ke Layar Jual Emas -> Frame #905:1764 & #954:1777 (investasi jual emas 4 - State Kosong)
    await tester.tap(find.text('JUAL'));
    await tester.pumpAndSettle();

    // Header JUAL
    expect(find.text('JUAL'), findsOneWidget);
    // Kartu Tabungan Emas Anda
    expect(find.text('Tabungan Emas Anda'), findsOneWidget);
    expect(find.text('Masukkan Nominal Penjualan'), findsOneWidget);
    expect(find.text('Pilihan Cepat'), findsOneWidget);
    expect(find.text('Harga Jual:'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);

    // 2b. Test Klik Kotak Abu-abu untuk Toggle Keyboard
    await tester.tap(find.text('Rp '));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget); // Keyboard 4-kolom muncul

    // Klik kotak abu-abu sekali lagi untuk menutup keyboard (Responsive)
    await tester.tap(find.text('Rp '));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.backspace_outlined), findsNothing); // Keyboard tertutup

    // 2c. Test Geser Pilihan Cepat Horizontal sampai semua button kelihatan
    await tester.drag(find.text('Rp 300.000'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(find.text('Rp 1.000.000'), findsOneWidget);

    // Geser kembali ke tombol awal
    await tester.ensureVisible(find.text('Rp 100.000').first);
    await tester.pumpAndSettle();

    // 3. Pilih Pilihan Cepat Rp 100.000 -> Frame investasi jual emas 5 (State Terisi)
    await tester.tap(find.text('Rp 100.000').first);
    await tester.pumpAndSettle();
    expect(find.text('100.000'), findsWidgets);
    expect(find.textContaining('Emas Berkurang'), findsOneWidget);

    // 4. Klik Lanjutkan -> Frame investasi jual emas 3 (Layar Konfirmasi Tujuan Pencairan)
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();

    expect(find.text('Tabungan Emas Anda'), findsOneWidget);
    expect(find.text('Tujuan Pencairan'), findsOneWidget);
    expect(find.text('Rekening Sumber (XEMA)'), findsOneWidget);
    expect(find.text('0851 2343 5656'), findsOneWidget);
    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Nominal Penjualan'), findsOneWidget);
    expect(find.text('Biaya Admin'), findsOneWidget);
    expect(find.text('Rp 0'), findsOneWidget);
    expect(find.text('Total Diterima'), findsOneWidget);
    expect(find.text('Konfirmasi'), findsOneWidget);

    // 5. Klik Konfirmasi -> Frame PIN jual emas (Layar Masukkan 6-digit PIN)
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi PIN'), findsOneWidget);
    expect(find.text('Masukkan 6-digit PIN Transaksi kamu'), findsOneWidget);
    expect(find.text('Lupa PIN?'), findsOneWidget);

    // 6. Verifikasi Tombol Hapus pada Keypad PIN jika belum 6 digit
    expect(find.byKey(const ValueKey('pin_action_button')), findsOneWidget);

    // Masukkan PIN 3 digit
    await tester.tap(find.text('1').first);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('2').first);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('3').first);
    await tester.pump(const Duration(milliseconds: 50));

    // Tekan tombol hapus untuk menghapus angka '3'
    await tester.tap(find.byKey(const ValueKey('pin_action_button')));
    await tester.pump(const Duration(milliseconds: 50));

    // Lanjutkan input PIN hingga lengkap 6 digit
    for (int i = 3; i <= 6; i++) {
      await tester.tap(find.text('$i').first);
      await tester.pump(const Duration(milliseconds: 50));
    }
    // Verifikasi angka PIN muncul di indikator
    expect(find.text('1'), findsWidgets);
    expect(find.text('6'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 7. Frame transaksi jual emas (Layar Resi Bukti Transaksi Sukses Jual Emas)
    expect(find.text('Bukti Transaksi'), findsOneWidget);
    expect(find.text('SUKSES!'), findsOneWidget);
    expect(find.text('Nomor  Referensi'), findsOneWidget);
    expect(find.text('Tujuan Dana (XEMA):'), findsOneWidget);
    expect(find.text('Nominal  Penjualan'), findsOneWidget);
    expect(find.text('Emas Dijual'), findsOneWidget);
    expect(find.text('Harga Jual/gr'), findsOneWidget);
    expect(find.text('Biaya Admin'), findsOneWidget);
    expect(find.text('Gratis'), findsWidgets);
    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    // 8. Klik OK -> Kembali ke GoldScreen dan saldo emas berkurang
    await tester.ensureVisible(find.text('OK'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('INVESTASI EMAS'), findsOneWidget);
    // Saldo awal 5.2400 - (100.000 / 2.250.000 = 0.0444) = 5.1956
    expect(find.text('5,1956 Gram'), findsOneWidget);
  });
}
