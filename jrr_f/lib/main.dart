import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/ssl_trust.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Install before any HttpClient is constructed so saved-server SSL hosts
  // can be added to the trust list as the session is restored.
  JRiverHttpOverrides.install();
  await configureDependencies();

  final talker = getIt<Talker>();

  // Flutter framework errors (widget build exceptions, layout overflows, etc.)
  FlutterError.onError = (FlutterErrorDetails details) {
    talker.error(
      'Flutter error: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  };

  // Errors thrown outside the Flutter framework (async gaps, platform channels)
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    talker.error('Uncaught platform error', error, stack);
    return true; // mark as handled
  };

  runApp(
    ProviderScope(observers: [TalkerRiverpodObserver()], child: const App()),
  );
}
