import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Freeman extends StatefulWidget {
  final int dice1 = 1;
  final int dice2 = 1;

  @override
  _FreemanBodyState createState() {
    return new _FreemanBodyState();
  }

}

class _FreemanBodyState extends State<Freeman>{
  int dice1 = 1,dice2 = 1;
  final random1 = math.Random();
  final random2 = math.Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Freeman"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _dice(dice1),
            _dice(dice2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            dice1 = random1.nextInt(6) + 1;
            dice2 = random2.nextInt(6) + 1;
          });
        },
        child: Icon(Icons.gamepad),
      ),
    );
  }

  Widget _dice(int dice) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 5.0, color: Colors.white)
      ),
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          child: Center(
            child: Container(
              child: Text(dice.toString(),
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


