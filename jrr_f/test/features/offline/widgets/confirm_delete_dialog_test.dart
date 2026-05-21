import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/offline/widgets/confirm_delete_dialog.dart';

void main() {
  testWidgets('Cancel returns false; Delete returns true', (tester) async {
    late Future<bool> result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                result = showConfirmDeleteDialog(
                  context: context,
                  title: 'Delete album?',
                  message: 'This removes the downloaded files.',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    // Open and tap Cancel.
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Delete album?'), findsOneWidget);
    expect(find.text('This removes the downloaded files.'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);

    // Open again and tap Delete.
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('honours a custom confirm label', (tester) async {
    late Future<bool> result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                result = showConfirmDeleteDialog(
                  context: context,
                  title: 'Clear?',
                  message: 'All of them?',
                  confirmLabel: 'Wipe',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Wipe'), findsOneWidget);
    await tester.tap(find.text('Wipe'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });
}
