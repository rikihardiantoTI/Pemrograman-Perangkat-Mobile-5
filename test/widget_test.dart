import 'package:flutter_test/flutter_test.dart';

import 'package:tugas_sesi_5/main.dart';

void main() {
  testWidgets('NusaEvent app displays its event tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NusaEventApp());

    expect(find.text('NusaEvent'), findsOneWidget);
    expect(find.text('Seminar'), findsOneWidget);
    expect(find.text('Galeri & Venue'), findsOneWidget);
    expect(find.text('Tiket'), findsOneWidget);
  });
}
