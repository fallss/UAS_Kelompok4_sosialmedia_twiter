import 'package:flutter/widgets.dart';
import 'delay_tween.dart';

class WidgetDotBounce extends StatefulWidget {
  final Color? color;
  final double size;
  final int count;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  const WidgetDotBounce({
    super.key,
    this.color,
    this.size = 18.0,
    this.count = 3,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
          'You should specify either an itemBuilder or a color');

  @override
  WidgetDotBounceState createState() => WidgetDotBounceState();
}

class WidgetDotBounceState extends State<WidgetDotBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(
            vsync: this,
            duration: Duration(milliseconds: widget.count * widget.duration.inMilliseconds)))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 3.2, widget.size * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.count, (i) {
            return SlideTransition(
              position: DelayTweenOffset(
                begin: const Offset(0, 0.5),
                end: const Offset(0, -0.5),
                delay: i * 0.2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
                child: widget.itemBuilder != null
                    ? widget.itemBuilder!(context, i)
                    : DecoratedBox(
                        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
