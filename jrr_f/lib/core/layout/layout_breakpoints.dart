import 'package:flutter/widgets.dart';

class LayoutBreakpoints {
  static const double wideScreen = 840;

  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width >= wideScreen;
  }

  static bool isNarrow(BuildContext context) {
    return MediaQuery.of(context).size.width < wideScreen;
  }
}
