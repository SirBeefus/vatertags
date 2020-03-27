import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide TextStyle;
import 'package:simple_animations/simple_animations.dart';


class Particles extends StatefulWidget {
  final int numberOfParticles;
  final String text;

  Particles(this.numberOfParticles, this.text);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];


  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      startTime: Duration(seconds: 1),
      onTick: _simulateParticles,
      builder: (context, time) {
        return CustomPaint(
          painter: ParticlePainter(particles, time, widget.text),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}

class ParticleModel {
  Animatable tween;
  double size;
  AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.4);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 500 + random.nextInt(12000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration + Duration(milliseconds: 6000), startTime: time);
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;
  String text;

  ParticlePainter(this.particles, this.time, this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow.withAlpha(50);

    particles.asMap().forEach((index, particle) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position = Offset(animation["x"] * size.width, animation["y"] * size.height);
      if(index == 15) {
        final textStyle = TextStyle(color: Color.fromRGBO(255, 127, 80, 0.5));
        final paragraphStyle = ParagraphStyle(textAlign: TextAlign.center);
        final paragraphBuilder = ParagraphBuilder(paragraphStyle)
          ..pushStyle(textStyle)
          ..addText(text);
        final paragraph = paragraphBuilder.build()
          ..layout(ParagraphConstraints(width: 100));
        canvas.drawParagraph(paragraph, position);
      }
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    });

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}