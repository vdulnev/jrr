import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_provider.dart';
import 'package:jrr_f/features/zones/widgets/zone_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

class _ZoneList extends ZoneList {
  _ZoneList(this._value);
  final AsyncValue<Zones> _value;
  @override
  Future<Zones> build() async {
    return _value.maybeWhen(
      data: (z) => z,
      orElse: () => throw _value.error ?? StateError('loading'),
    );
  }
}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required AsyncValue<Zones> zones,
    Zone? active,
    PlaybackState playback = PlaybackState.stopped,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          talkerProvider.overrideWithValue(Talker()),
          zoneListProvider.overrideWith(() => _ZoneList(zones)),
          if (active != null)
            activeZoneProvider.overrideWith(() => _Active(active)),
          playerProvider.overrideWith(
            () => TestPlayer(status: stoppedStatus(state: playback)),
          ),
        ],
        child: const MaterialApp(home: ZoneListScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the zone list with the active zone highlighted', (
    tester,
  ) async {
    const a = Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false);
    const b = Zone(id: '1', name: 'Speaker', guid: 'gb', isDLNA: true);
    await pump(
      tester,
      zones: const AsyncValue.data(Zones(zones: [a, b])),
      active: a,
      playback: PlaybackState.playing,
    );
    expect(find.text('Player'), findsOneWidget);
    expect(find.text('Speaker'), findsOneWidget);
    expect(find.text('DLNA'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('renders error view and exposes a retry button', (tester) async {
    await pump(
      tester,
      zones: AsyncValue.error(StateError('boom'), StackTrace.empty),
    );
    expect(find.byType(ZoneListScreen), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('refresh button is present in the header', (tester) async {
    await pump(tester, zones: const AsyncValue.data(Zones(zones: [])));
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
  });
}
