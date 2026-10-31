import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xema_app/gold_screen.dart';

void main() {
  testWidgets('GoldScreen renders all core Figma elements and interactions', (WidgetTester tester) async {
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

    // 1. Verify Header
    expect(find.text('INVESTASI EMAS'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // 2. Verify Tabungan Emas Card
    expect(find.text('Tabungan Emas Anda'), findsOneWidget);
    expect(find.text('5,2400 Gram'), findsOneWidget);
    expect(find.textContaining('Nilai Saat Ini:'), findsOneWidget);
    expect(find.text('+ Rp 100.000 (0.8%)'), findsOneWidget);

    // 3. Verify Harga Emas Hari Ini Section
    expect(find.text('Harga Emas Hari Ini'), findsOneWidget);
    expect(find.text('Jual'), findsOneWidget);
    expect(find.text('ke Aplikasi'), findsOneWidget);
    expect(find.text('Beli dari'), findsOneWidget);
    expect(find.text('Aplikasi'), findsOneWidget);
    expect(find.text('JUAL'), findsOneWidget);
    expect(find.text('BELI'), findsOneWidget);

    // 4. Verify Ringkasan Kinerja
    expect(find.text('Ringkasan Kinerja'), findsOneWidget);
    expect(find.text('Harga Rata-rata Beli'), findsOneWidget);
    expect(find.text('Rp 2.250.000 / gr'), findsOneWidget);
    expect(find.text('Total Modal Diinvestasikan'), findsOneWidget);
    expect(find.text('Rp 13.000.000 / gr'), findsOneWidget);

    // 5. Test Beli Bottom Sheet
    await tester.tap(find.text('BELI'));
    await tester.pumpAndSettle();
    expect(find.text('Beli Emas'), findsOneWidget);
    expect(find.text('KONFIRMASI BELI'), findsOneWidget);

    // Close bottom sheet
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 6. Test Jual Bottom Sheet
    await tester.tap(find.text('JUAL'));
    await tester.pumpAndSettle();
    expect(find.text('Jual Emas'), findsOneWidget);
    expect(find.text('KONFIRMASI JUAL'), findsOneWidget);
  });
}
