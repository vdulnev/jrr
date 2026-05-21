import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/shared/widgets/artwork_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectionRepo extends Mock implements ConnectionRepository {}

class _Session extends Session {
  _Session(this._state);
  final SessionState _state;
  @override
  SessionState build() => _state;
}

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    SessionState session = const SessionState.unauthenticated(),
    String? token,
  }) async {
    final repo = MockConnectionRepo();
    when(() => repo.currentToken).thenReturn(token);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(() => _Session(session)),
          connectionRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
  }

  testWidgets('null fileKey renders the placeholder icon', (tester) async {
    await pump(tester, const ArtworkWidget(fileKey: null));
    expect(find.byIcon(Icons.music_note), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('negative fileKey renders the placeholder icon', (tester) async {
    await pump(tester, const ArtworkWidget(fileKey: -1));
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('unauthenticated session renders the placeholder icon', (
    tester,
  ) async {
    await pump(tester, const ArtworkWidget(fileKey: 42));
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('authenticated session with token builds a network Image URL', (
    tester,
  ) async {
    await pump(
      tester,
      const ArtworkWidget(fileKey: 42),
      session: const SessionState.authenticated(
        serverInfo: ServerInfo(
          id: 's',
          name: 'n',
          version: 'v',
          platform: 'p',
          address: 'http://host:52199',
        ),
      ),
      token: 'tok',
    );
    final image = tester.widget<Image>(find.byType(Image));
    final url = (image.image as NetworkImage).url;
    expect(url, contains('File/GetImage?File=42'));
    expect(url, contains('Token=tok'));
  });
}
