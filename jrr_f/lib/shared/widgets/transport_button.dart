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
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.accent
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, Color(0xFFA07020)],
                  )
                : null,
            color: widget.accent
                ? null
                : (_pressed ? AppColors.bg3 : Colors.transparent),
            boxShadow: widget.accent
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
                  ? Colors.black
                  : (widget.color ?? AppColors.text2),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
