import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final String dbName = "friends.db";

Future<Database> getAppDb() async {
  return openDatabase(await getAppDbPath());
}

Future<String> getAppDbPath() async {
  var documentsDirectory = await getApplicationDocumentsDirectory();
  return join(documentsDirectory.path, dbName);
}