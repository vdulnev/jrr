import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/connection/providers/server_setup_provider.dart';
import 'package:jrr_f/features/connection/providers/server_setup_view_model.dart';
import 'package:jrr_f/features/connection/providers/server_setup_view_state.dart';
import 'package:jrr_f/features/connection/widgets/server_setup_screen.dart';

/// Stub view-model so the real `serverSetupFormProvider` (which would call
/// into the McwsApi to verify a server) is bypassed and we observe the
/// "is connecting / error" UI transitions directly.
class _Vm extends ServerSetupViewModel {
  _Vm({required this.recorder});
  final List<String> recorder;
  late ServerSetupViewState _state;

  @override
  ServerSetupViewState build() {
    _state = const ServerSetupViewState(
      isConnecting: false,
      connectError: null,
      prefill: null,
    );
    return _state;
  }

  void _push(ServerSetupViewState newState) {
    _state = newState;
    state = newState;
  }

  @override
  Future<void> connectWithAccessKey({
    required String accessKey,
    required String username,
    required String password,
    bool useSsl = false,
  }) async {
    recorder.add('accessKey:$accessKey/$useSsl');
    _push(
      const ServerSetupViewState(
        isConnecting: true,
        connectError: null,
        prefill: null,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    _push(
      const ServerSetupViewState(
        isConnecting: false,
        connectError: 'Server not reachable',
        prefill: null,
      ),
    );
  }

  @override
  Future<void> connectWithHost({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    int sslPort = 52200,
  }) async {
    recorder.add('host:$host:$port/$useSsl');
    _push(
      const ServerSetupViewState(
        isConnecting: true,
        connectError: null,
        prefill: null,
      ),
    );
    // Simulate success — landing on authenticated state would normally
    // unmount the screen via the routed shell; here we just verify the
    // loading indicator clears.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    _push(
      const ServerSetupViewState(
        isConnecting: false,
        connectError: null,
        prefill: null,
      ),
    );
  }

  @override
  Future<void> enterOfflineMode() async {
    recorder.add('offline');
  }
}

/// Resize the surface so the entire ServerSetupScreen (scrollable
/// content) is visible without scrolling — keeps taps simple.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(500, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Widget _harness({required _Vm vm}) {
  return ProviderScope(
    overrides: [
      serverSetupViewModelProvider.overrideWith(() => vm),
      // Block the real form notifier from running its constructor body.
      serverSetupFormProvider.overrideWith(() => _FormStub()),
    ],
    child: MaterialApp(theme: buildAppTheme(), home: const ServerSetupScreen()),
  );
}

class _FormStub extends ServerSetupForm {
  @override
  AsyncValue<void>? build() => null;
}

void main() {
  testWidgets(
    'access key journey: shown errors, then re-submit clears form state',
    (tester) async {
      final recorder = <String>[];
      final vm = _Vm(recorder: recorder);

      _useTallSurface(tester);
      await tester.pumpWidget(_harness(vm: vm));
      await tester.pumpAndSettle();

      expect(find.text('JRiver Remote'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);

      // Validator fails for empty access key.
      await tester.tap(find.text('Connect'));
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
      expect(recorder, isEmpty);

      // Type a key and connect.
      await tester.enterText(find.byType(TextFormField).first, 'abc123');
      await tester.tap(find.text('Connect'));
      // Loading spinner shows while connecting.
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle and the recorded error should surface.
      await tester.pumpAndSettle();
      expect(recorder, ['accessKey:abc123/false']);
      expect(find.text('Server not reachable'), findsOneWidget);
      // The button is back to "Connect" — no longer loading.
      expect(find.text('Connect'), findsOneWidget);
    },
  );

  testWidgets(
    'host & port journey: switch mode, fill fields, toggle SSL, connect',
    (tester) async {
      final recorder = <String>[];
      final vm = _Vm(recorder: recorder);

      _useTallSurface(tester);
      await tester.pumpWidget(_harness(vm: vm));
      await tester.pumpAndSettle();

      // Switch to manual mode.
      await tester.tap(find.text('Host & Port'));
      await tester.pumpAndSettle();
      // The form rebuilt; field labels render via InputDecoration.
      expect(find.text('Host'), findsOneWidget);
      expect(find.text('Port'), findsOneWidget);

      // Empty host → validator fails.
      await tester.tap(find.text('Connect'));
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);

      // Fill host, leave port default (52199).
      await tester.enterText(find.byType(TextFormField).at(0), '10.0.0.5');

      // Toggle SSL on — should reveal the SSL port field.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.text('SSL Port'), findsOneWidget);

      // Press connect — success path.
      await tester.tap(find.text('Connect'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(recorder, ['host:10.0.0.5:52199/true']);
      // No error text now.
      expect(find.text('Server not reachable'), findsNothing);
    },
  );

  testWidgets('offline journey: tapping Continue Offline invokes the VM', (
    tester,
  ) async {
    final recorder = <String>[];
    final vm = _Vm(recorder: recorder);

    _useTallSurface(tester);
    await tester.pumpWidget(_harness(vm: vm));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue Offline'));
    await tester.pumpAndSettle();

    expect(recorder, ['offline']);
  });
}
