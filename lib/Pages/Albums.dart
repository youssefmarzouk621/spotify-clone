import 'package:flutter/material.dart';
import 'package:music_player/Statics/MusicAppBar.dart';

/// widget that show a gridView with all albums of a specific artist
class Albums extends StatefulWidget {
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        MusicAppBar(title: "Albums"),
      ]),
    );
  }
}
