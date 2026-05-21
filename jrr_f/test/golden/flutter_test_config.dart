import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Auto-loaded by `flutter test` for every test in this directory.
///
/// Installs a [_TolerantGoldenComparator] that allows a small per-pixel
/// difference between captured and stored golden PNGs. Font rasterization
/// and anti-aliasing differ slightly between macOS (where these goldens
/// were generated) and the Linux CI runners (where they're verified), so
/// strict pixel equality is impractical without committing platform-
/// specific golden sets. A 2% tolerance hides those host differences while
/// still catching real layout/colour regressions.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final original = goldenFileComparator;
  if (original is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenComparator(
      original,
      // Reject diffs above 2% — enough to allow font/AA jitter across
      // macOS vs. Linux CI but still flag real layout/colour regressions.
      toleranceFraction: 0.02,
    );
  }
  await testMain();
}

class _TolerantGoldenComparator extends GoldenFileComparator {
  _TolerantGoldenComparator(this.inner, {required this.toleranceFraction});

  final LocalFileComparator inner;
  final double toleranceFraction;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final goldenBytes = await _readGoldenBytes(golden);
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      goldenBytes,
    );
    if (result.passed) return true;
    if (result.diffPercent <= toleranceFraction) {
      debugPrint(
        'Golden $golden within tolerance: '
        '${(result.diffPercent * 100).toStringAsFixed(2)}% '
        '<= ${(toleranceFraction * 100).toStringAsFixed(0)}%',
      );
      return true;
    }
    throw FlutterError(
      'Golden "$golden": Pixel test failed, '
      '${(result.diffPercent * 100).toStringAsFixed(2)}%, exceeds '
      '${(toleranceFraction * 100).toStringAsFixed(0)}% tolerance.',
    );
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) =>
      inner.update(golden, imageBytes);

  Future<Uint8List> _readGoldenBytes(Uri golden) async {
    final file = File.fromUri(inner.basedir.resolveUri(golden));
    return file.readAsBytes();
  }
}
