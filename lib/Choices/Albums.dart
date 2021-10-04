import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/Choices/CardAlbumWidget.dart';
import 'package:music_player/Statics/MusicAppBar.dart';

/// widget that show a gridView with all albums of a specific artist
class Albums extends StatefulWidget {
  final List<AlbumInfo> albums;

  Albums({this.albums});

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        MusicAppBar(title: "Albums"),
        SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            AlbumInfo album = widget.albums[index];

            return (album.albumArt == null)
                ? FutureBuilder<Uint8List>(
                    future: audioQuery.getArtwork(
                        type: ResourceType.ALBUM, id: album.id),
                    builder: (_, snapshot) {
                      if (snapshot.data == null)
                        return Container(
                          height: 250.0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                      return CardAlbumWidget(
                        title: album.title,
                        artist: album.artist,
                        rawImage: snapshot.data,
                        //backgroundImage: album.albumArt,
                      );
                    })
                : CardAlbumWidget(
                    title: album.title,
                    artist: album.artist,
                    backgroundImage: album.albumArt,
                  );
          }, childCount: widget.albums.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        ),
      ]),
    );
  }
}
