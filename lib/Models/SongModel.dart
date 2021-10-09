class SongModel {
  String albumId;
  String artistId;
  String artist;
  String album;
  String title;
  String displayName;
  String composer;
  String year;
  String track;
  String duration;
  String bookmark;
  String filePath;
  String uri;
  String fileSize;
  String albumArtwork;
  bool isMusic;
  bool isPodcast;
  bool isRingtone;
  bool isAlarm;
  bool isNotification;

  SongModel.fromJSON(Map<String, dynamic> json) {
    this.albumId = json['albumId'] as String;
    this.artistId = json['artistId'] as String;
    this.artist = json['artist'] as String;
    this.album = json['album'] as String;
    this.title = json[' title'] as String;
    this.displayName = json['displayName'] as String;
    this.composer = json['composer'] as String;
    this.year = json['year'] as String;
    this.track = json['track'] as String;
    this.duration = json['duration'] as String;
    this.bookmark = json['bookmark'] as String;
    this.filePath = json['filePath'] as String;
    this.uri = json['uri'] as String;
    this.fileSize = json['fileSize'] as String;
    this.albumArtwork = json['albumArtwork'] as String;
    this.isMusic = json['isMusic'] as bool;
    this.isPodcast = json['isPodcast'] as bool;
    this.isRingtone = json['isRingtone'] as bool;
    this.isAlarm = json['isAlarm'] as bool;
    this.isNotification = json['isNotification'] as bool;
  }
}
