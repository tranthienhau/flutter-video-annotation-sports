import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_live_sports_scores/src/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The mock repository emits an infinite stream (a tick every 3s), so we use
  // fixed pump durations instead of pumpAndSettle (which would hang forever).
  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 600));
    await binding.takeScreenshot(name);
  }

  testWidgets('capture live sports score flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LiveScoresApp()));
    await tester.pump(const Duration(milliseconds: 800));

    // 01 - match list with live, scheduled and finished fixtures.
    await shoot(tester, '01-match-list');

    // 02 - open a live match detail (Arsenal vs Man City) with event timeline.
    await tester.tap(find.text('Arsenal'));
    await tester.pump(const Duration(milliseconds: 800));
    await shoot(tester, '02-match-detail');

    // 03 - back to the live feed.
    await tester.tap(find.byTooltip('Back'));
    await tester.pump(const Duration(milliseconds: 800));
    await shoot(tester, '03-live-feed');
  });
}
