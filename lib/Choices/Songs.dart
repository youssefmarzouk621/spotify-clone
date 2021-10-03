import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/Statics/MusicAppBar.dart';

class Songs extends StatefulWidget {
  final List<SongInfo> _songs;
  Songs(this._songs);
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 10),
      child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        MusicAppBar(title: "Songs"),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (widget._songs[index].isMusic) {
              return _buildSongCard(
                  leading: (widget._songs[index].albumArtwork == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.SONG,
                              id: widget._songs[index].id,
                              size: Size(800, 800)),
                          builder: (_, snapshot) {
                            if (snapshot.data == null)
                              return CircleAvatar(
                                child: CircularProgressIndicator(),
                              );
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
                  song: widget._songs[index]);
            } else {
              return Container();
            }
          }, childCount: widget._songs.length),
        )
      ]),
    );
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
