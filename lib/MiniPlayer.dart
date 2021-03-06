import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/Statics/Statics.dart';

import 'CustomWidgets/gradient_containers.dart';
import 'MusicPlayer.dart';

import 'package:music_player/main.dart';

class MiniPlayer extends StatefulWidget {
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Route playScreenRoute(
      {Map<dynamic, dynamic> data,
      bool fromMiniplayer,
      bool displayNowPlaying}) {
    return PageRouteBuilder(
      //barrierDismissible: true,
      //barrierColor: Colors.transparent,
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => PlayScreen(
        data: data,
        fromMiniplayer: fromMiniplayer,
        displayNowPlaying: displayNowPlaying,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          if (snapshot.data == null) {
            return SizedBox();
          }
          final processingState = playbackState.processingState;
          if (processingState == AudioProcessingState.idle) {
            return const SizedBox();
          }
          return StreamBuilder<MediaItem>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return const SizedBox();
                }
                final mediaItem = snapshot.data;
                if (mediaItem == null) return const SizedBox();
                return Dismissible(
                  background: Container(
                    color: Colors.transparent,
                  ),
                  key: Key(mediaItem.id),
                  onDismissed: (_) {
                    audioHandler.stop();
                  },
                  child: GradientCard(
                      miniplayer: true,
                      radius: 0.0,
                      elevation: 0.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(playScreenRoute(
                                  data: {
                                    'response': [],
                                    'index': 1,
                                    'offline': null,
                                  },
                                  fromMiniplayer: true,
                                  displayNowPlaying: false));
                              /*Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (_, __, ___) =>
                                      const PlayScreen(
                                    data: {
                                      'response': [],
                                      'index': 1,
                                      'offline': null,
                                    },
                                    fromMiniplayer: true,
                                    displayNowPlaying: false,
                                  ),
                                ),
                              );*/
                            },
                            title: Text(
                              mediaItem.title,
                              style: TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              mediaItem.artist ?? '',
                              style: TextStyle(color: Colors.white38),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Hero(
                                tag: 'currentArtwork',
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3.0,
                                        offset: Offset(1, 1),
                                        // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  /*elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(7.0)),
                                  clipBehavior: Clip.antiAlias,*/
                                  child: (mediaItem.artUri
                                          .toString()
                                          .startsWith('file:'))
                                      ? Container(
                                          height: 50.0,
                                          width: 50.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(mediaItem
                                                    .artUri
                                                    .toFilePath()))),
                                          ),
                                        )
                                      : Container(
                                          height: 50.0,
                                          width: 50.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                errorWidget: (BuildContext
                                                            context,
                                                        _,
                                                        __) =>
                                                    const Image(
                                                      image: AssetImage(
                                                          'assets/cover.jpg'),
                                                    ),
                                                placeholder:
                                                    (BuildContext context, _) =>
                                                        const Image(
                                                          image: AssetImage(
                                                              'assets/cover.jpg'),
                                                        ),
                                                imageUrl: mediaItem.artUri
                                                    .toString()),
                                          ),
                                        ),
                                )),
                            trailing: ControlButtons(
                              audioHandler,
                              miniplayer: true,
                            ),
                          ),
                          StreamBuilder<Duration>(
                              stream: AudioService.position,
                              builder: (context, snapshot) {
                                final position = snapshot.data;
                                return position == null
                                    ? const SizedBox()
                                    : (position.inSeconds.toDouble() < 0.0 ||
                                            (position.inSeconds.toDouble() >
                                                mediaItem.duration.inSeconds
                                                    .toDouble()))
                                        ? const SizedBox()
                                        : SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              activeTrackColor:
                                                  Palette.primaryColor,
                                              inactiveTrackColor:
                                                  Colors.transparent,
                                              trackHeight: 0.5,
                                              thumbColor: Palette.primaryColor,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                      enabledThumbRadius: 1.0),
                                              overlayColor: Colors.transparent,
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                      overlayRadius: 2.0),
                                            ),
                                            child: Slider(
                                              inactiveColor: Colors.transparent,
                                              // activeColor: Colors.white,
                                              value:
                                                  position.inSeconds.toDouble(),
                                              max: mediaItem.duration.inSeconds
                                                  .toDouble(),
                                              onChanged: (newPosition) {
                                                audioHandler.seek(Duration(
                                                    seconds:
                                                        newPosition.round()));
                                              },
                                            ),
                                          );
                              }),
                        ],
                      )),
                );
              });
        });
  }
}
