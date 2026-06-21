// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna/main.dart';

void main() {
  testWidgets('Luna opens the emotional timeline feed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LunaApp());

    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('O comeco'), findsWidgets);
  });

  for (final size in <Size>[
    const Size(320, 568),
    const Size(800, 600),
    const Size(1440, 900),
  ]) {
    testWidgets('layout has no overflow at ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LunaApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final timelineDestination = find.text('Tempo');
      await tester.tap(timelineDestination);
      await tester.pumpAndSettle();

      expect(find.text('Linha do tempo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
