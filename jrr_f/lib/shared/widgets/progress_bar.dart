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

  double _calcProgress(Offset localPosition, double width) {
    return (localPosition.dx / width).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) {
        setState(() => _dragging = true);
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          widget.onChanged?.call(
            _calcProgress(d.localPosition, box.size.width),
          );
        }
      },
      onPanUpdate: (d) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          widget.onChanged?.call(
            _calcProgress(d.localPosition, box.size.width),
          );
        }
      },
      onPanEnd: (_) => setState(() => _dragging = false),
      onTapDown: (d) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          widget.onChanged?.call(
            _calcProgress(d.localPosition, box.size.width),
          );
        }
      },
      child: SizedBox(
        height: 32,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: _dragging ? 6 : 3,
            decoration: BoxDecoration(
              color: AppColors.bg4,
              borderRadius: BorderRadius.circular(3),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * widget.progress;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: width,
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
                        left: width - 7,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
