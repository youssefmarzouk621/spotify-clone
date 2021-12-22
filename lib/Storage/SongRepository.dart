import 'package:music_player/Models/CachedSongs.dart';
import 'package:music_player/Storage/DatabaseCreator.dart';

class UsersRepository {
  static Future<List<CachedSong>> getAllSongs() async {
    await DatabaseCreator().initDatabase();

    final sql = "SELECT * FROM '${DatabaseCreator.SongsTable}'";
    final data = await db.rawQuery(sql);
    List<CachedSong> songs = [];

    for (final node in data) {
      final song = CachedSong.fromJson(node);
      songs.add(song);
    }
    return songs;
  }

  /*static Future<bool> shouldReload() async {
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  
    List<SongModel> storedSongs = await getAllSongs();
    List<SongInfo> list = await audioQuery.getSongs();

    if (storedSongs.length == list.length) {
      return false;
    } else {
      return true;
    }
  }*/

  static Future<List<CachedSong>> getSongsByArtist(int artistId) async {
    final sql =
        "SELECT * FROM ${DatabaseCreator.SongsTable} WHERE 'artistId' = ?";

    List<dynamic> params = [artistId];

    final data = await db.rawQuery(sql, params);

    List<CachedSong> songs = [];

    for (final node in data) {
      final song = CachedSong.fromJson(node);
      songs.add(song);
    }
    return songs;
  }

  /*static Future<void> addSong(CachedSong song) async {
    await DatabaseCreator().initDatabase();

    final sql = '''INSERT INTO ${DatabaseCreator.SongsTable}
    (
      "id",
      "albumId",
      "artistId",
      "artist",
      "album",
      "title",
      "displayName",
      "composer",
      "year",
      "track",
      "duration",
      "bookmark",
      "filePath",
      "uri",
      "fileSize",
      "albumArtwork",
      "isMusic",
      "isPodcast",
      "isRingtone",
      "isAlarm",
      "isNotification"
    )
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''';

    List<dynamic> params = [
      song.albumId,
      song.artistId,
      song.artist,
      song.album,
      song.title,
      song.displayName,
      song.composer,
      song.year,
      song.track,
      song.duration,
      song.bookmark,
      song.filePath,
      song.uri,
      song.fileSize,
      song.albumArtwork,
      song.isMusic,
      song.isPodcast,
      song.isRingtone,
      song.isAlarm,
      song.isNotification
    ];

    final result = await db.rawInsert(sql, params);
    print("user inserted");
  }
*/

  /*static Future<void> addSongs(List<CachedSong> songs) async {
    for (var i = 0; i < songs.length; i++) {
      await addSong(songs[i]);
    }

    print("added multiple");
  }*/
}
