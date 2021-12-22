class CachedSong {
  String uri;
  String artist;
  String year;
  String isMusic;
  String title;
  String genreId;
  String size;
  String displayNameWoExt;
  String albumArtist;
  String genre;
  String data;
  String displayName;
  String album;
  String composer;
  String fileExtension;
  String image;

  int duration;
  int isAlarm;
  int isNotification;
  int track;
  int isRingtone;
  int artistId;
  int isPodcast;
  int bookmark;
  int dateAdded;
  int isAudiobook;
  int dateModified;
  int albumId;
  int id;

  CachedSong(
      {this.uri,
      this.artist,
      this.year,
      this.isMusic,
      this.title,
      this.genreId,
      this.size,
      this.duration,
      this.isAlarm,
      this.displayNameWoExt,
      this.albumArtist,
      this.genre,
      this.isNotification,
      this.track,
      this.data,
      this.displayName,
      this.album,
      this.composer,
      this.isRingtone,
      this.artistId,
      this.isPodcast,
      this.bookmark,
      this.dateAdded,
      this.isAudiobook,
      this.dateModified,
      this.albumId,
      this.fileExtension,
      this.id,
      this.image});

  CachedSong.fromJson(Map<String, dynamic> json) {
    uri = json['_uri'] as String;
    artist = json['artist'] as String;
    year = json['year'] as String;
    isMusic = json['is_music'] as String;
    title = json['title'] as String;
    genreId = json['genre_id'] as String;
    size = json['_size'] as String;
    displayNameWoExt = json['_display_name_wo_ext'] as String;
    albumArtist = json['album_artist'] as String;
    genre = json['genre'] as String;
    data = json['_data'] as String;
    displayName = json['_display_name'] as String;
    album = json['album'] as String;
    composer = json['composer'] as String;
    fileExtension = json['file_extension'] as String;
    image = json['image'] as String;

    duration = json['duration'] as int;
    isAlarm = json['is_alarm'] as int;
    isNotification = json['is_notification'] as int;
    track = json['track'] as int;
    isRingtone = json['is_ringtone'] as int;
    artistId = json['artist_id'] as int;
    isPodcast = json['is_podcast'] as int;
    bookmark = json['bookmark'] as int;
    dateAdded = json['date_added'] as int;
    isAudiobook = json['is_audiobook'] as int;
    dateModified = json['date_modified'] as int;
    albumId = json['album_id'] as int;

    id = json['_id'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_uri'] = this.uri;
    data['artist'] = this.artist;
    data['year'] = this.year;
    data['is_music'] = this.isMusic;
    data['title'] = this.title;
    data['genre_id'] = this.genreId;
    data['_size'] = this.size;
    data['duration'] = this.duration;
    data['is_alarm'] = this.isAlarm;
    data['_display_name_wo_ext'] = this.displayNameWoExt;
    data['album_artist'] = this.albumArtist;
    data['genre'] = this.genre;
    data['is_notification'] = this.isNotification;
    data['track'] = this.track;
    data['_data'] = this.data;
    data['_display_name'] = this.displayName;
    data['album'] = this.album;
    data['composer'] = this.composer;
    data['is_ringtone'] = this.isRingtone;
    data['artist_id'] = this.artistId;
    data['is_podcast'] = this.isPodcast;
    data['bookmark'] = this.bookmark;
    data['date_added'] = this.dateAdded;
    data['is_audiobook'] = this.isAudiobook;
    data['date_modified'] = this.dateModified;
    data['album_id'] = this.albumId;
    data['file_extension'] = this.fileExtension;
    data['_id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
