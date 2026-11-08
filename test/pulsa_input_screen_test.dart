import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xema_app/ppob_screen.dart';

void main() {
  testWidgets('PulsaInputScreen empty initial, toggle grey box, keypad and laptop keyboard test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PulsaInputScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Initial State: nomor kosong, placeholder muncul
    expect(find.text('Masukan Nomor Handphone'), findsOneWidget);
    // Keypad belum muncul (tidak ada tombol backspace keypad)
    expect(find.byIcon(Icons.backspace_outlined), findsNothing);

    // 2. Klik Kotak Abu-Abu -> Keypad muncul
    await tester.tap(find.text('Masukan Nomor Handphone'));
    await tester.pumpAndSettle();

    // Sekarang tombol keypad muncul
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // 3. Ketik angka pakai On-Screen Keypad HP
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    expect(find.text('081'), findsOneWidget);

    // 4. Input via Keyboard Laptop / PC (HardwareKeyboard)
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2, character: '2');
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit3, character: '3');
    await tester.pumpAndSettle();
    expect(find.text('08123'), findsOneWidget);

    // 5. Backspace via Keyboard Laptop
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();
    expect(find.text('0812'), findsOneWidget);

    // 6. Klik tombol Ceklis / Submit -> Pindah ke Catalog Screen
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(PulsaCatalogScreen), findsOneWidget);
  });
}
