import 'dart:io';
import 'package:flutter/material.dart';

class CardAlbumWidget extends StatelessWidget {
  final String backgroundImage, title, artist;
  final List<int> rawImage;
  static const titleMaxLines = 2;
  static const titleTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0);

  CardAlbumWidget({
    this.backgroundImage,
    this.title = "Title",
    this.rawImage,
    this.artist = "artist",
  });

  @override
  Widget build(BuildContext context) {
    final hasRawImage = !(rawImage == null || rawImage.isEmpty);

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (backgroundImage == null && !hasRawImage)
              ? AssetImage("assets/no_cover.png")
              : (hasRawImage)
                  ? MemoryImage(rawImage) // Image.memory(rawImage)
                  : FileImage(File(backgroundImage)),
          fit: BoxFit.fill,
          alignment: AlignmentDirectional.topCenter,
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            color: Theme.of(context).backgroundColor.withOpacity(0.4),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            height: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
