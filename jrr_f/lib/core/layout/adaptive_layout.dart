import 'package:flutter/widgets.dart';
import 'layout_breakpoints.dart';

class AdaptiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) narrowBuilder;
  final Widget Function(BuildContext context) wideBuilder;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.narrowBuilder,
    required this.wideBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= LayoutBreakpoints.wideScreen) {
          return wideBuilder(context);
        }
        return narrowBuilder(context);
      },
    );
  }
}
