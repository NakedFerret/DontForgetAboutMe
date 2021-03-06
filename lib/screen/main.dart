import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dont_forget_about_me/screen/friends_list.dart';
import 'package:dont_forget_about_me/screen/add_friend.dart';
import 'package:dont_forget_about_me/util/db.dart';

void main() async {
  await initDb();
  runApp(new MyApp());
}

initDb() async {
  String path = await getAppDbPath();

  await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS friends (
        id INTEGER PRIMARY KEY,
        name TEXT,
        frequency INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS greetings (
        id INTEGER PRIMARY KEY,
        friend_id INTEGER,
        date INTEGER
      );
    ''');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FriendsList(),
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: <String, WidgetBuilder>{
        'add-friend': (buildContext) => new AddFriend(),
      },
    );
  }
}
