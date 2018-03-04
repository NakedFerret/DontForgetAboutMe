import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'friends_list.dart';
import 'util/db.dart';

void main() async {
  await initDb();
  runApp(new MyApp());
}

initDb() async {
  String path = await getAppDbPath();

  deleteDatabase(path);

  await openDatabase(path, version: 1,
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FriendsList(),
    );
  }
}
