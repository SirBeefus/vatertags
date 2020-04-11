import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ostsee extends StatefulWidget {
  @override
  _OstseeState createState() {
    return _OstseeState();
  }
}

class _OstseeState extends State<Ostsee> {
  List items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ostsee')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Text("Shuffle"),
        onPressed: (){
          setState(() {
            items.shuffle();
            items.forEach((element) {print(items==null ? "nothing" : element.record);});
            print("-------------------------------------------");
          });
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ostsee').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildStack(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildStack(BuildContext context, List<DocumentSnapshot> snapshot) {
    items = snapshot.map((data) => _buildCard(context, data)).toList();
    items.shuffle();
    return Center(
      child: Stack(
        children: items,
      ),
    );
  }

  Widget _buildCard(BuildContext context, DocumentSnapshot data) {
    final record = RecordOstsee.fromSnapshot(data);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return OstseeCard(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        record: record,
    );
  }
}

class RecordOstsee {
  final String name;
  final String action;
  final DocumentReference reference;

  RecordOstsee.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['action'] != null),
        name = map['name'],
        action = map['action'];

  RecordOstsee.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$action>";
}

class OstseeCard extends StatefulWidget {
  final RecordOstsee record;
  final double screenWidth;
  final double screenHeight;
  final Color color = Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);

  OstseeCard({this.screenWidth, this.screenHeight, this.record});

  @override
  _OstseeCardState createState() {
    return _OstseeCardState();
  }
}

class _OstseeCardState extends State<OstseeCard> with SingleTickerProviderStateMixin{
  Animation<double> animationWidth;
  Animation<double> animationHeight;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animationWidth = Tween<double>(begin: widget.screenWidth * 0.66, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    animationHeight = Tween<double>(begin: widget.screenHeight / 1.5, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.transparent,
        elevation: 4.0,
        child: Container(
          width:  animationWidth.value ,
          height:  animationHeight.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: animationWidth.value,
                height: animationHeight.value * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(widget.record.name, style: TextStyle(fontSize: animationWidth.value/10)),
                    Text("---------", style: TextStyle(fontSize: animationWidth.value/10)),
                    Text(widget.record.action.toString(), style: TextStyle(fontSize: animationWidth.value/10)),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        controller.forward();
      },
    );
  }

}