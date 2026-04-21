import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class VUMeter extends StatefulWidget {
  final bool active;

  const VUMeter({required this.active, super.key});

  @override
  State<VUMeter> createState() => _VUMeterState();
}

class _VUMeterState extends State<VUMeter> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(VUMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final phase = (i * 0.12 + _controller.value) * 2 * pi;
              final h = widget.active
                  ? 6.0 + 14.0 * ((sin(phase) + 1) / 2)
                  : 4.0;
              return Container(
                width: 2,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(
                    alpha: widget.active ? 0.9 : 0.2,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
