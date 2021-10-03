import 'package:flutter/material.dart';

class MusicAppBar extends StatefulWidget {
  final String title;
  MusicAppBar({@required this.title});
  @override
  _MusicAppBarState createState() => _MusicAppBarState();
}

class _MusicAppBarState extends State<MusicAppBar> {
  @override
  SliverAppBar build(BuildContext context) {
    return SliverAppBar(
      elevation: 5,
      shadowColor: Theme.of(context).shadowColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.title,
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 19,
                fontWeight: FontWeight.bold)),
      ),
      brightness: Brightness.dark,
      backgroundColor: Theme.of(context).backgroundColor,
      expandedHeight: 110,
      pinned: true,
    );
  }
}

