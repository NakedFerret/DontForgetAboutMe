import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'util/db.dart';

class FriendsList extends StatefulWidget {
  @override
  createState() => new FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List<Map> _friends = new List<Map>();

  getFriends() async {
    Database db = await getAppDb();
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
