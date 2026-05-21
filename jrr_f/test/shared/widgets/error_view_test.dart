import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/shared/widgets/error_view.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('connectionRefused → address-aware message', (tester) async {
    await pump(
      tester,
      const ErrorView(
        error: AppException.connectionRefused(address: '10.0.0.1:52199'),
      ),
    );
    expect(
      find.textContaining('Cannot connect to 10.0.0.1:52199'),
      findsOneWidget,
    );
  });

  testWidgets('unauthorized → check credentials message', (tester) async {
    await pump(tester, const ErrorView(error: AppException.unauthorized()));
    expect(find.textContaining('Authentication failed'), findsOneWidget);
  });

  testWidgets('serverFailure includes the message verbatim', (tester) async {
    await pump(
      tester,
      const ErrorView(error: AppException.serverFailure(message: 'Bad XML')),
    );
    expect(find.textContaining('Bad XML'), findsOneWidget);
  });

  testWidgets('parseError includes the details', (tester) async {
    await pump(
      tester,
      const ErrorView(error: AppException.parseError(details: 'Missing tag')),
    );
    expect(find.textContaining('Missing tag'), findsOneWidget);
  });

  testWidgets('timeout includes the address', (tester) async {
    await pump(
      tester,
      const ErrorView(error: AppException.timeout(address: 'host:52199')),
    );
    expect(find.textContaining('host:52199'), findsOneWidget);
    expect(find.textContaining('timed out'), findsOneWidget);
  });

  testWidgets('database error surfaces the raw error string', (tester) async {
    await pump(
      tester,
      const ErrorView(error: AppException.database(error: 'locked')),
    );
    expect(find.textContaining('locked'), findsOneWidget);
  });

  testWidgets('non-AppException falls back to toString', (tester) async {
    await pump(tester, ErrorView(error: StateError('plain boom')));
    expect(find.textContaining('plain boom'), findsOneWidget);
  });

  testWidgets('Retry button appears when onRetry is provided', (tester) async {
    var retried = 0;
    await pump(
      tester,
      ErrorView(
        error: const AppException.unauthorized(),
        onRetry: () => retried++,
      ),
    );
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(retried, 1);
  });

  testWidgets('Retry button is hidden when onRetry is null', (tester) async {
    await pump(tester, const ErrorView(error: AppException.unauthorized()));
    expect(find.text('Retry'), findsNothing);
  });
}
