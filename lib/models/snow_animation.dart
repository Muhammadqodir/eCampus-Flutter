// ignore_for_file: unnecessary_new, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';

class SnowWidget extends StatefulWidget {
  final int totalSnow;
  final double speed;
  final bool isRunning;

  SnowWidget({
    Key? key,
    required this.totalSnow,
    required this.speed,
    required this.isRunning,
  }) : super(key: key);

  @override
  _SnowWidgetState createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  late Random _rnd;
  late AnimationController controller;
  List<Snow>? _snows;
  double angle = 0;
  double W = 0;
  double H = 0;

  @override
  void initState() {
    super.initState();
    _rnd = Random();
    controller = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    )..addListener(() {
        if (mounted) {
          setState(() {
            update();
          });
        }
      });

    if (!widget.isRunning) {
      controller.stop();
    } else {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _createSnow() {
    _snows = List.generate(
      widget.totalSnow,
      (i) => Snow(
        x: _rnd.nextDouble() * W,
        y: _rnd.nextDouble() * H,
        r: _rnd.nextDouble() * 4 + 1,
        d: _rnd.nextDouble() * widget.speed,
      ),
    );
  }

  void update() {
    angle += 0.01;
    if (_snows == null || widget.totalSnow != _snows!.length) {
      _createSnow();
    }
    for (var i = 0; i < widget.totalSnow; i++) {
      var snow = _snows![i];
      snow.y += (cos(angle + snow.d) + 1 + snow.r / 2) * widget.speed;
      snow.x += sin(angle) * 2 * widget.speed;
      if (snow.x > W + 5 || snow.x < -5 || snow.y > H) {
        if (i % 3 > 0) {
          _snows![i] =
              Snow(x: _rnd.nextDouble() * W, y: -10, r: snow.r, d: snow.d);
        } else {
          if (sin(angle) > 0) {
            _snows![i] =
                Snow(x: -5, y: _rnd.nextDouble() * H, r: snow.r, d: snow.d);
          } else {
            _snows![i] =
                Snow(x: W + 5, y: _rnd.nextDouble() * H, r: snow.r, d: snow.d);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.isRunning && controller.isAnimating) {
      controller.stop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_snows == null) {
          W = constraints.maxWidth;
          H = constraints.maxHeight;
        }
        return CustomPaint(
          willChange: widget.isRunning,
          painter: SnowPainter(
            isRunning: widget.isRunning,
            snows: _snows!,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Snow {
  double x;
  double y;
  double r; //radius
  double d; //density

  Snow({
    required this.x,
    required this.y,
    required this.r,
    required this.d,
  });
}

class SnowPainter extends CustomPainter {
  List<Snow> snows;
  bool isRunning;

  SnowPainter({
    required this.isRunning,
    required this.snows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (snows == null || !isRunning) return;

    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (var i = 0; i < snows.length; i++) {
      var snow = snows[i];
      if (snow != null) {
        canvas.drawCircle(Offset(snow.x, snow.y), snow.r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => isRunning;
}
