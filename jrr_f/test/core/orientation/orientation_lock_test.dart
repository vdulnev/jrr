import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/orientation/orientation_lock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final binding =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  final calls = <List<dynamic>>[];

  setUp(() {
    calls.clear();
    binding.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'SystemChrome.setPreferredOrientations') {
        calls.add(List<dynamic>.from(call.arguments as List));
      }
      return null;
    });
  });

  tearDown(() {
    binding.setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size),
        child: const OrientationLock(child: SizedBox.shrink()),
      ),
    );
    // Drain the post-frame callback that issues setPreferredOrientations.
    await tester.pump();
  }

  testWidgets('locks to portrait for phone-class widths', (tester) async {
    await pumpAt(tester, const Size(360, 800));
    expect(calls, isNotEmpty);
    expect(
      calls.last,
      containsAll(<String>[
        'DeviceOrientation.portraitUp',
        'DeviceOrientation.portraitDown',
      ]),
    );
  });

  testWidgets('unlocks rotation for tablet-class widths', (tester) async {
    await pumpAt(tester, const Size(900, 1200));
    expect(calls, isNotEmpty);
    expect(calls.last, isEmpty);
  });

  testWidgets('does not re-issue the lock when size stays in phone band', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 800));
    calls.clear();
    await pumpAt(tester, const Size(380, 820));
    expect(calls, isEmpty);
  });

  testWidgets('re-issues the lock when crossing the 600dp threshold', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 800));
    calls.clear();
    await pumpAt(tester, const Size(900, 1200));
    expect(calls, hasLength(1));
    expect(calls.last, isEmpty);
  });

  testWidgets('uses shortestSide so portrait tablets unlock too', (
    tester,
  ) async {
    await pumpAt(tester, const Size(700, 1200));
    expect(calls.last, isEmpty);
  });

  testWidgets('renders the provided child', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: Size(360, 800)),
        child: OrientationLock(child: SizedBox(key: ValueKey('child'))),
      ),
    );
    expect(find.byKey(const ValueKey('child')), findsOneWidget);
  });
}
