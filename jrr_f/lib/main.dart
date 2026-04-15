import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/logging/riverpod_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    ProviderScope(observers: [AppRiverpodObserver(talker)], child: const App()),
  );
}
