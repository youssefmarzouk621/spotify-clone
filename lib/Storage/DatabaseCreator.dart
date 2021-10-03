import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const SongsTable = 'Songs';

  Future<void> createSongsTable(Database db) async {
    final songSql = '''CREATE TABLE $SongsTable
    (
      "id" TEXT PRIMARY KEY,
      "albumId" TEXT,
      "artistId" TEXT,
      "artist" TEXT,
      "album" TEXT,
      "title" TEXT,
      "displayName" TEXT,
      "composer" TEXT,
      "year" TEXT,
      "track" TEXT,
      "duration" TEXT,
      "bookmark" TEXT,
      "filePath" TEXT,
      "uri" TEXT,
      "fileSize" TEXT,
      "albumArtwork" TEXT,
      "isMusic" TEXT,
      "isPodcast" TEXT,
      "isRingtone" TEXT,
      "isAlarm" TEXT,
      "isNotification" TEXT
    )''';

    await db.execute(songSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('Music_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print("database init success");
  }

  Future<void> onCreate(Database db, int version) async {
    await createSongsTable(db);
  }
}
