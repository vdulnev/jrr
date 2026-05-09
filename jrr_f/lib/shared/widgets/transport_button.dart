import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class TransportButton extends StatefulWidget {
  final Widget child;
  final double size;
  final bool accent;
  final VoidCallback? onPressed;
  final Color? color;

  const TransportButton({
    required this.child,
    this.size = 48,
    this.accent = false,
    this.onPressed,
    this.color,
    super.key,
  });

  @override
  State<TransportButton> createState() => _TransportButtonState();
}

class _TransportButtonState extends State<TransportButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.accent && enabled
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, Color(0xFFA07020)],
                  )
                : null,
            color: widget.accent
                ? (enabled ? null : AppColors.bg3)
                : (_pressed ? AppColors.bg3 : Colors.transparent),
            boxShadow: widget.accent && enabled
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: widget.accent
                  ? (enabled ? Colors.black : AppColors.text3)
                  : (enabled
                        ? (widget.color ?? AppColors.text2)
                        : AppColors.text3),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
