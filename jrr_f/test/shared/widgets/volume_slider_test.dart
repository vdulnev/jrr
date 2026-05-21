import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/volume_slider.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SizedBox(width: 250, child: child)),
    ),
  );

  testWidgets('renders volume percentage label', (tester) async {
    await pump(tester, VolumeSlider(value: 0.42, onChanged: (_) {}));
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('volume_up icon shown when not muted and value > 0', (
    tester,
  ) async {
    await pump(tester, VolumeSlider(value: 0.5, onChanged: (_) {}));
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
  });

  testWidgets('volume_off icon shown when muted', (tester) async {
    await pump(
      tester,
      VolumeSlider(value: 0.5, onChanged: (_) {}, isMuted: true),
    );
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('volume_off icon shown when value is 0', (tester) async {
    await pump(tester, VolumeSlider(value: 0.0, onChanged: (_) {}));
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('tap on the track reports a fractional value', (tester) async {
    final emissions = <double>[];
    await pump(tester, VolumeSlider(value: 0.0, onChanged: emissions.add));
    final center = tester.getCenter(find.byType(VolumeSlider));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    expect(emissions, isNotEmpty);
    expect(emissions.last, inInclusiveRange(0.0, 1.0));
  });

  testWidgets('IconButton fires onMuteToggle', (tester) async {
    var toggled = 0;
    await pump(
      tester,
      VolumeSlider(
        value: 0.5,
        onChanged: (_) {},
        onMuteToggle: () => toggled++,
      ),
    );
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(toggled, 1);
  });
}
