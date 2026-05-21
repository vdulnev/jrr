import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/providers/download_status_provider.dart';
import 'package:jrr_f/features/offline/widgets/download_progress_indicator.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required DownloadState status,
    double progress = 0,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          downloadStatusProvider(1).overrideWith((ref) => status),
          downloadProgressProvider(1).overrideWith((ref) => progress),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DownloadProgressIndicator(fileKey: 1)),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('queued shows a spinner', (tester) async {
    await pump(tester, status: DownloadState.queued);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('running shows progress indicator', (tester) async {
    await pump(tester, status: DownloadState.running, progress: 0.5);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('downloaded shows a check icon', (tester) async {
    await pump(tester, status: DownloadState.downloaded);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('failed shows an error icon', (tester) async {
    await pump(tester, status: DownloadState.failed);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('notDownloaded renders nothing', (tester) async {
    await pump(tester, status: DownloadState.notDownloaded);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
