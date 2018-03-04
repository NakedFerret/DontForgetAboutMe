import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var documentsDirectory = await getApplicationDocumentsDirectory();
  var path = join(documentsDirectory.path, "friends.db");

  deleteDatabase(path);

  Database db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute('''
      CREATE TABLE friends (
        id INTEGER PRIMARY KEY,
        name TEXT,
        frequency INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE greetings (
        id INTEGER PRIMARY KEY,
        friend_id INTEGER,
        date INTEGER
      );
    ''');

    int count = Sqflite
        .firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM friends"));

    // Only put in dummy data if the table is empty
    if (count > 0) return;

    await db.execute('''
      INSERT INTO FRIENDS(name, frequency) VALUES('Spongebob', 2);
    ''');

    await db.execute('''
      INSERT INTO FRIENDS(name, frequency) VALUES('Sandy', 2);
    ''');

    await db.execute('''
      INSERT INTO FRIENDS(name, frequency) VALUES('Patrick', 2);
    ''');

    await db.execute('''
      INSERT INTO FRIENDS(name, frequency) VALUES('Squidward', 2);
    ''');
  });

  runApp(new MyApp(db));
}

class MyApp extends StatelessWidget {
  final Database db;

  MyApp(this.db);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  List<Map> _friends = new List<Map>();

  getFriends() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "friends.db");

    Database db = await openDatabase(path, version: 1);
    List<Map> result = await db.rawQuery('SELECT * FROM friends');

    setState(() {
      _friends.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  Widget _buildRow(Map friend) {
    return new ListTile(
      title: new Text(
        friend == null ? 'Nobody' : friend['name'],
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        itemCount: _friends.length * 2,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;

          return _buildRow(index < _friends.length ? _friends[index] : null);
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('People Important To Me'),
      ),
      body: _buildSuggestions(),
    );
  }
}
