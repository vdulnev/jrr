import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

/// Re-applies the portrait-only lock on phone-class screens and unlocks on
/// tablet-class screens, re-evaluated whenever MediaQuery changes.
///
/// The startup lock in `main.dart` covers cold start; this widget covers the
/// foldable case where the device crosses the 600dp threshold mid-session
/// (unfolding/folding, multi-window resize, external display attached).
class OrientationLock extends StatefulWidget {
  final Widget child;

  const OrientationLock({super.key, required this.child});

  @override
  State<OrientationLock> createState() => _OrientationLockState();
}

class _OrientationLockState extends State<OrientationLock> {
  bool? _lockedToPortrait;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    final isPhone = size.shortestSide < 600;
    if (_lockedToPortrait == isPhone) return;
    _lockedToPortrait = isPhone;
    // Defer to next frame — never fire platform channel calls during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations(
        isPhone
            ? const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]
            : const <DeviceOrientation>[], // empty = OS default (allow all)
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
