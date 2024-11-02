import 'package:flutter/animation.dart';

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, this.delay = 0.0}) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((t - delay).clamp(0.0, 1.0));
  }
}

class DelayTweenOffset extends Tween<Offset> {
  final double delay;

  DelayTweenOffset({required Offset begin, required Offset end, this.delay = 0.0}) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    return super.lerp((t - delay).clamp(0.0, 1.0));
  }
}
