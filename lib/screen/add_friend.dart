import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dont_forget_about_me/util/db.dart';

class AddFriend extends StatefulWidget {
  @override
  createState() => new AddFriendState();
}

class AddFriendState extends State<AddFriend> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _daysController = new TextEditingController();

  addFriend() async {
    Database db = await getAppDb();
    await db.insert('friends', {
      "name": _nameController.text,
      "frequency": _daysController.text,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Important Person'),
        ),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new TextField(
                controller: _nameController,
                decoration: new InputDecoration(
                  hintText: 'Person',
                ),
              ),
              new TextField(
                controller: _daysController,
                decoration: new InputDecoration(
                  hintText: 'Days',
                ),
              ),
              new RaisedButton(
                onPressed: addFriend,
                child: new Text('Help me remember'),
              ),
            ],
          ),
          padding: new EdgeInsets.all(32.0),
        ));

  }
}
