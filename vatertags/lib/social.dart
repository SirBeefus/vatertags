import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() {
    return _SocialPageState();
  }
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Schnappsvorfreudekapazitätsindex',
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 14),
          )
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('biervorfreudekapazitätsindex').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(255, 255, 0, record.count/1000)
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.count.toString()),
          onTap: () => record.reference.updateData({'count': FieldValue.increment(1)})
//              Firestore.instance.runTransaction((transaction) async {
//            final freshSnapshot = await transaction.get(record.reference);
//            final fresh = Record.fromSnapshot(freshSnapshot);
//            await transaction
//                .update(record.reference, {'count': fresh.count + 1})
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int count;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['count'] != null),
        name = map['name'],
        count = map['count'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$count>";
}