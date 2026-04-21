import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class VolumeSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback? onMuteToggle;
  final bool isMuted;

  const VolumeSlider({
    required this.value,
    required this.onChanged,
    this.onMuteToggle,
    this.isMuted = false,
    super.key,
  });

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  bool _dragging = false;

  double _calcValue(Offset localPosition, double width) {
    return (localPosition.dx / width).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isMuted ? AppColors.text3 : AppColors.accent;

    return Row(
      children: [
        IconButton(
          onPressed: widget.onMuteToggle,
          icon: Icon(
            widget.isMuted || widget.value == 0
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            size: 20,
            color: widget.isMuted ? AppColors.accent : AppColors.text2,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        Expanded(
          child: GestureDetector(
            onPanStart: (d) {
              setState(() => _dragging = true);
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                widget.onChanged(_calcValue(d.localPosition, box.size.width));
              }
            },
            onPanUpdate: (d) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                widget.onChanged(_calcValue(d.localPosition, box.size.width));
              }
            },
            onPanEnd: (_) => setState(() => _dragging = false),
            onTapDown: (d) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                widget.onChanged(_calcValue(d.localPosition, box.size.width));
              }
            },
            child: SizedBox(
              height: 32,
              child: Center(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bg4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth * widget.value;
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
                                borderRadius: BorderRadius.circular(2),
                                color: color,
                              ),
                            ),
                          ),
                          Positioned(
                            left: width - (8 * (_dragging ? 1.2 : 1.0)),
                            top: -6 * (_dragging ? 1.2 : 1.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: 16 * (_dragging ? 1.2 : 1.0),
                              height: 16 * (_dragging ? 1.2 : 1.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.text,
                                border: Border.all(color: AppColors.bg1, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '${(widget.value * 100).round()}',
            style: const TextStyle(
              fontFamily: AppFonts.mono,
              fontSize: 10,
              color: AppColors.text3,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
