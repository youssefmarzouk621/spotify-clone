import 'package:flutter/material.dart';
import 'package:music_player/Statics/MusicAppBar.dart';

class Artist extends StatefulWidget {
  final String ArtistName;
  final String imagePath;

  Artist({this.ArtistName,this.imagePath});
  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        minimum: EdgeInsets.only(left: 10),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
          SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.ArtistName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                centerTitle: true,
                background: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.imagePath),
                          fit: BoxFit.cover)),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    color: Theme.of(context).primaryColor.withOpacity(.05),
                  ),
                ),
              ),
            )
          ]
        )
    );
  }
}

