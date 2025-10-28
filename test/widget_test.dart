// GameOne Widget Test

import 'package:flutter_test/flutter_test.dart';
import 'package:game_one/main.dart';

void main() {
  testWidgets('GameOne app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GameOneApp());

    // Verify that app title exists
    expect(find.text('GameOne'), findsOneWidget);
    
    // Verify that basic elements exist
    expect(find.text('Koleksi Game Favorit'), findsOneWidget);
  });
}
