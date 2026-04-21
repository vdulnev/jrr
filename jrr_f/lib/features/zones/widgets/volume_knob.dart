import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class VolumeKnob extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const VolumeKnob({required this.value, required this.onChanged, super.key});

  @override
  State<VolumeKnob> createState() => _VolumeKnobState();
}

class _VolumeKnobState extends State<VolumeKnob> {
  static const _size = 120.0;
  static const _startAngle = 0.75 * pi; // 135 degrees — bottom-left
  static const _sweepRange = 1.5 * pi; // 270 degrees total

  bool _dragging = false;

  double _angleToValue(Offset localPosition) {
    const center = Offset(_size / 2, _size / 2);
    final delta = localPosition - center;
    var angle = atan2(delta.dy, delta.dx);
    // Normalize relative to start angle
    var relative = angle - _startAngle;
    if (relative < -pi) relative += 2 * pi;
    if (relative > pi) relative -= 2 * pi;
    if (relative < 0) relative = 0;
    return (relative / _sweepRange).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) {
        _dragging = true;
        widget.onChanged(_angleToValue(d.localPosition));
      },
      onPanUpdate: (d) {
        if (_dragging) {
          widget.onChanged(_angleToValue(d.localPosition));
        }
      },
      onPanEnd: (_) => _dragging = false,
      child: SizedBox(
        width: _size,
        height: _size,
        child: CustomPaint(
          painter: _KnobPainter(
            value: widget.value,
            trackColor: AppColors.bg4,
            activeColor: AppColors.accent,
            knobColor: AppColors.bg3,
            dotColor: AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double value;
  final Color trackColor;
  final Color activeColor;
  final Color knobColor;
  final Color dotColor;

  _KnobPainter({
    required this.value,
    required this.trackColor,
    required this.activeColor,
    required this.knobColor,
    required this.dotColor,
  });

  static const _startAngle = 0.75 * pi;
  static const _sweepRange = 1.5 * pi;
  static const _trackWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Track arc (background)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _trackWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      _sweepRange,
      false,
      trackPaint,
    );

    // Active arc
    if (value > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _trackWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _startAngle,
        _sweepRange * value,
        false,
        activePaint,
      );
    }

    // Inner knob circle
    final knobRadius = radius - 14;
    final knobPaint = Paint()..color = knobColor;
    canvas.drawCircle(center, knobRadius, knobPaint);

    // Knob border
    final borderPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, knobRadius, borderPaint);

    // Indicator dot on the knob
    final dotAngle = _startAngle + _sweepRange * value;
    final dotRadius = knobRadius - 10;
    final dotCenter = Offset(
      center.dx + dotRadius * cos(dotAngle),
      center.dy + dotRadius * sin(dotAngle),
    );
    final dotPaint = Paint()..color = value > 0 ? activeColor : dotColor;
    canvas.drawCircle(dotCenter, 3, dotPaint);
  }

  @override
  bool shouldRepaint(_KnobPainter old) => old.value != value;
}
