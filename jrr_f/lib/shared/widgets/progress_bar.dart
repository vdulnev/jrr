import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppProgressBar extends StatefulWidget {
  final double progress;
  final ValueChanged<double>? onChanged;

  const AppProgressBar({required this.progress, this.onChanged, super.key});

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final filledWidth = fullWidth * widget.progress;

        void report(Offset localPosition) {
          widget.onChanged?.call(
            (localPosition.dx / fullWidth).clamp(0.0, 1.0),
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) {
            setState(() => _dragging = true);
            report(d.localPosition);
          },
          onPanUpdate: (d) => report(d.localPosition),
          onPanEnd: (_) => setState(() => _dragging = false),
          onPanCancel: () => setState(() => _dragging = false),
          onTapDown: (d) => report(d.localPosition),
          child: SizedBox(
            height: 48,
            width: fullWidth,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: _dragging ? 6 : 3,
                width: fullWidth,
                decoration: BoxDecoration(
                  color: AppColors.bg4,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: filledWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            colors: [Color(0xCCC8922A), AppColors.accent],
                          ),
                        ),
                      ),
                    ),
                    if (_dragging)
                      Positioned(
                        left: filledWidth - 7,
                        top: -4,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
