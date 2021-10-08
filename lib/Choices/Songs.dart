import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/MusicPlayer.dart';
import 'package:music_player/Statics/MusicAppBar.dart';
import 'package:music_player/Statics/Statics.dart';

class Songs extends StatefulWidget {
  final List<SongInfo> _songs;

  Songs(this._songs);
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> _displayedSongs = [];

  @override
  void initState() {
    super.initState();
    setState(() => _displayedSongs = widget._songs);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 10),
      child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        MusicAppBar(title: "Songs"),
        SliverAppBar(
          pinned: true,
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          title: buildSearchField(Icons.search_rounded, "Search",
              onChanged: (value) {
            setState(() {
              if (value.length != 0) {
                _displayedSongs = widget._songs
                    .where((song) =>
                        song.title.toLowerCase().startsWith(value) ||
                        song.artist.toLowerCase().startsWith(value))
                    .toList();
              } else {
                _displayedSongs = widget._songs;
              }
            });
          }),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (_displayedSongs[index].isMusic) {
              return _buildSongCard(
                  leading: (_displayedSongs[index].albumArtwork == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.SONG,
                              id: _displayedSongs[index].id,
                              size: Size(800, 800)),
                          builder: (_, snapshot) {
                            if (snapshot.data == null)
                              return LoadingAnimation();
                            if (snapshot.data.isEmpty)
                              return CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/no_cover.png"),
                              );

                            return Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(snapshot.data),
                                    fit: BoxFit.cover,
                                    alignment: AlignmentDirectional.center,
                                  ),
                                ));
                          })
                      : null,
                  song: _displayedSongs[index],
                  onPressed: () async {
                    Uint8List imgBytes = await audioQuery.getArtwork(
                        type: ResourceType.SONG,
                        id: _displayedSongs[index].id,
                        size: Size(800, 800));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicDetailPage(
                                  color: Theme.of(context).primaryColor,
                                  songInfo: _displayedSongs[index],
                                  imgBytes: imgBytes,
                                )));
                  });
            } else {
              return Container();
            }
          }, childCount: _displayedSongs.length),
        )
      ]),
    );
  }

  Widget buildSearchField(IconData icon, String hintText, {onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Colors.white70,
          filled: true,
          prefixIcon: Icon(
            icon,
            color: Colors.black87,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildImage(SongInfo songInfo) {
    if (songInfo.albumArtwork == null) {
      return FutureBuilder<Uint8List>(
          future: audioQuery.getArtwork(
              type: ResourceType.SONG, id: songInfo.id, size: Size(800, 800)),
          builder: (_, snapshot) {
            if (snapshot.data == null) return LoadingAnimation();
            if (snapshot.data.isEmpty)
              return CircleAvatar(
                backgroundImage: AssetImage("assets/no_cover.png"),
              );

            return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(snapshot.data),
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional.center,
                  ),
                ));
          });
    } else {
      return null;
    }
  }

  Widget _buildSongCard({SongInfo song, Function onPressed, Widget leading}) {
    return Card(
      elevation: 0.5,
      color: Theme.of(context).backgroundColor,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: song.id,
                child: leading,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3),
                    Text(
                      song.artist,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
