import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/services/android_auto_player_service.dart';
import 'package:jrr_f/features/player/services/jrr_audio_handler.dart';
import 'package:jrr_f/features/zones/services/android_auto_session_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockHandler extends Mock implements JrrAudioHandler {}

class MockAutoPlayer extends Mock implements AndroidAutoPlayerService {}

class FakeAudioHandler extends Fake implements BaseAudioHandler {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeAudioHandler());
  });

  late MockHandler handler;
  late MockAutoPlayer autoPlayer;
  late AndroidAutoSessionService service;

  setUp(() {
    handler = MockHandler();
    autoPlayer = MockAutoPlayer();
    service = AndroidAutoSessionService(
      talker: Talker(),
      handlerResolver: () => handler,
      autoPlayerResolver: () => autoPlayer,
    );
  });

  tearDown(() {
    service.dispose();
  });

  group('isConnected', () {
    test('starts disconnected', () {
      expect(service.isConnected.value, isFalse);
    });

    test('markActive flips to true and switches the handler', () {
      service.markActive();
      expect(service.isConnected.value, isTrue);
      verify(() => handler.switchTo(autoPlayer)).called(1);
    });

    test('markActive is a no-op when already connected', () {
      service.markActive();
      clearInteractions(handler);
      service.markActive(isDirectSignal: true);
      expect(service.isConnected.value, isTrue);
      verifyNever(() => handler.switchTo(any()));
    });

    test('markInactive flips back to false', () {
      service.markActive();
      service.markInactive();
      expect(service.isConnected.value, isFalse);
    });

    test('markInactive when already disconnected is a no-op', () {
      service.markInactive();
      expect(service.isConnected.value, isFalse);
    });

    test('markActive tolerates missing handler/autoPlayer', () {
      service.dispose();
      service = AndroidAutoSessionService(
        talker: Talker(),
        handlerResolver: () => null,
        autoPlayerResolver: () => null,
      );
      service.markActive();
      expect(service.isConnected.value, isTrue);
    });

    test('markActive surfaces switchTo throws via talker without crashing', () {
      when(() => handler.switchTo(autoPlayer)).thenThrow(StateError('boom'));
      // Should not propagate — error is logged, isConnected still flips true.
      service.markActive();
      expect(service.isConnected.value, isTrue);
    });
  });

  group('native MethodChannel onConnectionChanged', () {
    const channel = MethodChannel('com.jrr.jrr_f/android_auto');

    Future<void> emit({required bool connected}) async {
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(
              MethodCall('onConnectionChanged', connected),
            ),
            (_) {},
          );
    }

    test('connected=true triggers markActive', () async {
      await emit(connected: true);
      expect(service.isConnected.value, isTrue);
    });

    test('connected=false triggers markInactive', () async {
      service.markActive();
      await emit(connected: false);
      expect(service.isConnected.value, isFalse);
    });
  });
}
