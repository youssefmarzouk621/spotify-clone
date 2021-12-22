import 'package:music_player/Models/CachedSongs.dart';

class HNPlaylistModel {
  String title;
  int duration;
  DateTime dateCreated;
  List<CachedSong> songs;

  HNPlaylistModel({this.title, this.duration, this.dateCreated, this.songs});
}
