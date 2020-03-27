import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;
import 'particle.dart';
import 'social.dart';
import 'wave.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
  theme: ThemeData(
    canvasColor: Colors.black54,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    accentColor: Colors.amberAccent,
    brightness: Brightness.dark,
  ),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {

//Timer controller
  AnimationController timeController;

  String get timerString {
    Duration duration = timeController.duration * timeController.value;
    return 'Es sind noch\n\n${(duration.inDays).toString()} Tage\n${duration.inHours % 24} Stunden \n${duration.inMinutes % 60} Minuten\n${(duration.inSeconds % 60).toString().padLeft(2, '0')} Sekunden\n\nbis Vatertag';
  }

  @override
  void initState() {

//  Timer and Circle
    DateTime vatertag = DateTime(2020, 5, 21);
    DateTime now = DateTime.now();
    int dateDiff = now.difference(vatertag).inSeconds;
    super.initState();
    timeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: dateDiff < 0 ? -dateDiff : dateDiff),
    );
    timeController.reverse(
        from: timeController.value == 0.0
            ? 1.0
            : timeController.value);
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: timeController,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                                  animation: timeController,
                                  backgroundColor: Colors.yellow,
                                  color: themeData.indicatorColor,
                                )
                            );
                          }),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                                animation: timeController,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timerString,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.yellow
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      Positioned.fill(child: Particles(30, 'Bier'))
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Stack(
                children: <Widget>[
                  new WaveBody(
                    size: size,
                    xOffset: 0,
                    yOffset: 0,
                    color: Colors.yellow,
                    duration: Duration(seconds: 6),
                    text: Text(
                      'Bier',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: new WaveBody(
                      size: size,
                      xOffset: 50,
                      yOffset: 10,
                      color: Colors.yellow,
                      duration: Duration(seconds: 9),
                      text: Text(
                        ''
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: new WaveBody(
                      size: size,
                      xOffset: 50,
                      yOffset: 10,
                      color: Colors.yellow,
                      duration: Duration(seconds: 14),
                      text: Text(
                          ''
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orangeAccent,
                      elevation: 20,
                      child: Icon(Icons.local_drink),
                      onPressed: (){
                        Navigator.of(context).push(_createRoute());
                      },
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}


Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SocialPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}