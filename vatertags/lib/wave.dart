import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';

class WaveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;
  final Duration duration;
  final Text text;

  WaveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color, this.duration, this.text})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _WaveBodyState();
  }
}

class _WaveBodyState extends State<WaveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this,
        duration: widget.duration
    );

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
      i <= widget.size.width.toInt() + 2;
      i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            math.sin((animationController.value * 360 - i) %
                360 *
                Vector.degrees2Radians) *
                20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: Stack(
              children: <Widget> [
                Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.color,
                  child: widget.text,
                ),
              ]
          ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}