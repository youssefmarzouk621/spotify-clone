import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/CustomWidgets/seek_bar.dart';
import 'package:music_player/Helpers/mediaitem_converter.dart';
import 'package:music_player/Statics/Statics.dart';
import 'package:music_player/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'Helpers/config.dart';

class PlayScreen extends StatefulWidget {
  final Map data;
  final bool fromMiniplayer;
  final bool displayNowPlaying;
  final bool recommend;
  const PlayScreen({
    @required this.data,
    @required this.fromMiniplayer,
    @required this.displayNowPlaying,
    this.recommend = true,
  });

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool fromMiniplayer = false;
  String preferredQuality = '96 kbps';
  String repeatMode = 'None';
  bool enforceRepeat = false;
  bool shuffle = false;
  bool useImageColor = true;

  List<MediaItem> globalQueue = [];
  int globalIndex = 0;
  bool same = false;
  List response = [];
  bool fetched = false;
  bool offline = false;
  bool downloaded = false;
  bool fromYT = false;
  String defaultCover = '';
  final ValueNotifier<Color> gradientColor = ValueNotifier<Color>(Colors.black);

  void sleepTimer(int time) {
    audioHandler.customAction('sleepTimer', {'time': time});
  }

  void sleepCounter(int count) {
    audioHandler.customAction('sleepCounter', {'count': count});
  }

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
  }

  Future<MediaItem> setTags(Map response, Directory tempDir) async {
    String playTitle = response['title'].toString();
    playTitle == ''
        ? playTitle = response['_display_name_wo_ext'].toString()
        : playTitle = response['title'].toString();
    String playArtist = response['artist'].toString();
    playArtist == '<unknown>'
        ? playArtist = 'Unknown'
        : playArtist = response['artist'].toString();

    final String playAlbum = response['album'].toString();
    final int playDuration = response['duration'] as int ?? 180000;
    String filePath;
    if (response['image'] != null) {
      try {
        final File file =
            File('${tempDir.path}/${response["_display_name_wo_ext"]}.jpg');
        filePath = file.path;
        if (!await file.exists()) {
          await file.create();
          file.writeAsBytesSync(response['image'] as Uint8List);
        }
      } catch (e) {
        filePath = null;
      }
    } else {
      filePath = await getImageFileFromAssets();
    }

    final MediaItem tempDict = MediaItem(
        id: response['_id'].toString(),
        album: playAlbum,
        duration: Duration(milliseconds: playDuration),
        title: playTitle != null ? playTitle.split('(')[0] : 'Unknown',
        artist: playArtist ?? 'Unknown',
        artUri: Uri.file(filePath),
        extras: {
          'url': response['_data'].toString(),
        });
    return tempDict;
  }

  Future<String> getImageFileFromAssets() async {
    if (defaultCover != '') return defaultCover;
    final file = File('${(await getTemporaryDirectory()).path}/cover.jpg');
    defaultCover = file.path;
    if (await file.exists()) return file.path;
    final byteData = await rootBundle.load('assets/cover.jpg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file.path;
  }

  void setOffValues(List response, {bool downloaed = false}) {
    getTemporaryDirectory().then((tempDir) async {
      final File file =
          File('${(await getTemporaryDirectory()).path}/cover.jpg');
      if (!await file.exists()) {
        final byteData = await rootBundle.load('assets/cover.jpg');
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }
      for (int i = 0; i < response.length; i++) {
        globalQueue.add(await setTags(response[i] as Map, tempDir));
      }
      fetched = true;
      updateNplay();
    });
  }

  void setDownValues(List response) {
    globalQueue.addAll(
      response
          .map((song) => MediaItemConverter().downMapToMediaItem(song as Map)),
    );
    fetched = true;
    updateNplay();
  }

  void setValues(List response) {
    globalQueue.addAll(
      response.map((song) => MediaItemConverter()
          .mapToMediaItem(song as Map, autoplay: widget.recommend)),
    );
    fetched = true;
  }

  Future<void> updateNplay() async {
    await audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    await audioHandler.updateQueue(globalQueue);
    await audioHandler.skipToQueueItem(globalIndex);
    await audioHandler.play();
    if (enforceRepeat) {
      switch (repeatMode) {
        case 'None':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
          break;
        case 'All':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
          break;
        case 'One':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
          break;
        default:
          break;
      }
    } else {
      audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext scaffoldContext;
    final Map data = widget.data;
    if (response == data['response'] && globalIndex == data['index']) {
      same = true;
    }
    response = data['response'] as List;
    globalIndex = data['index'] as int;
    if (globalIndex == -1) {
      globalIndex = 0;
    }
    fromYT = data['fromYT'] as bool ?? false;
    downloaded = data['downloaded'] as bool ?? false;
    if (data['offline'] == null) {
      if (audioHandler.mediaItem.value.extras['url'].startsWith('http')
          as bool) {
        offline = false;
      } else {
        offline = true;
      }
    } else {
      offline = data['offline'] as bool;
    }

    if (!fetched) {
      if (response.isEmpty || same) {
        fromMiniplayer = true;
      } else {
        fromMiniplayer = false;
        if (!enforceRepeat) {
          repeatMode = 'None';
        }
        shuffle = false;
        if (offline) {
          downloaded ? setDownValues(response) : setOffValues(response);
        } else {
          setValues(response);
          updateNplay();
        }
      }
    }

    Future<void> getColors(ImageProvider imageProvider) async {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(imageProvider);
      gradientColor.value = paletteGenerator.dominantColor.color;
      currentTheme.setLastPlayGradient(gradientColor.value);
    }

    return Dismissible(
      direction: DismissDirection.down,
      background: Container(color: Colors.transparent),
      key: const Key('playScreen'),
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: StreamBuilder<MediaItem>(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            final MediaItem mediaItem = snapshot.data;
            if (mediaItem == null) return const SizedBox();
            mediaItem.artUri.toString().startsWith('file')
                ? getColors(FileImage(File(mediaItem.artUri.toFilePath())))
                : getColors(
                    CachedNetworkImageProvider(mediaItem.artUri.toString()));
            return ValueListenableBuilder(
                valueListenable: gradientColor,
                builder: (BuildContext context, Color value, Widget child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [
                          value ?? const Color(0xfff5f9ff),
                          Colors.black,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          leading: IconButton(
                              icon: const Icon(Icons.expand_more_rounded),
                              tooltip: 'Back',
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          actions: [],
                        ),
                        body: Builder(builder: (BuildContext context) {
                          scaffoldContext = context;
                          return LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            if (constraints.maxWidth > constraints.maxHeight) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Artwork
                                  ArtWorkWidget(
                                    mediaItem,
                                    constraints.maxHeight / 0.9,
                                    offline: offline,
                                  ),

                                  // title and controls
                                  SizedBox(
                                    width: constraints.maxWidth / 2,
                                    child: NameNControls(
                                      mediaItem,
                                      offline: offline,
                                      displayNowPlaying:
                                          widget.displayNowPlaying,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                // Artwork
                                ArtWorkWidget(
                                  mediaItem,
                                  constraints.maxWidth,
                                  offline: offline,
                                ),

                                // title and controls
                                Expanded(
                                  child: NameNControls(
                                    mediaItem,
                                    offline: offline,
                                    displayNowPlaying: widget.displayNowPlaying,
                                  ),
                                ),
                              ],
                            );
                          });
                        }),

                        // }
                      ),
                    ),
                  );
                });
            // );
          }),
    );
  }
}

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int queueIndex;
  final List<int> shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
      this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final bool shuffle;
  final bool miniplayer;

  const ControlButtons(this.audioHandler,
      {this.shuffle = false, this.miniplayer = false});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data ?? QueueState.empty;
              return IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: miniplayer ? 24.0 : 45.0,
                tooltip: 'Skip Previous',
                color: queueState.hasPrevious ? Colors.white : Colors.white38,
                onPressed: queueState.hasPrevious
                    ? audioHandler.skipToPrevious
                    : () => print("no previous"),
              );
            },
          ),
          SizedBox(
            height: miniplayer ? 40.0 : 65.0,
            width: miniplayer ? 40.0 : 65.0,
            child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing ?? false;
                  return Stack(
                    children: [
                      if (processingState == AudioProcessingState.loading ||
                          processingState == AudioProcessingState.buffering)
                        Center(
                          child: SizedBox(
                            height: miniplayer ? 40.0 : 65.0,
                            width: miniplayer ? 40.0 : 65.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                      if (miniplayer)
                        Center(
                            child: playing
                                ? IconButton(
                                    tooltip: 'Pause',
                                    onPressed: audioHandler.pause,
                                    icon: const Icon(
                                      Icons.pause_rounded,
                                    ),
                                    color: Colors.white,
                                  )
                                : IconButton(
                                    tooltip: 'Play',
                                    onPressed: audioHandler.play,
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                    ),
                                    color: Colors.white,
                                  ))
                      else
                        Center(
                          child: SizedBox(
                              height: 59,
                              width: 59,
                              child: Center(
                                child: playing
                                    ? FloatingActionButton(
                                        elevation: 10,
                                        tooltip: 'Pause',
                                        backgroundColor: Colors.white,
                                        onPressed: audioHandler.pause,
                                        child: const Icon(
                                          Icons.pause_rounded,
                                          size: 40.0,
                                          color: Colors.black,
                                        ),
                                      )
                                    : FloatingActionButton(
                                        elevation: 10,
                                        tooltip: 'Play',
                                        backgroundColor: Colors.white,
                                        onPressed: audioHandler.play,
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 40.0,
                                          color: Colors.black,
                                        ),
                                      ),
                              )),
                        ),
                    ],
                  );
                }),
          ),
          StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data ?? QueueState.empty;
              return IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: miniplayer ? 24.0 : 45.0,
                tooltip: 'Skip Next',
                color: queueState.hasNext ? Colors.white : Colors.white38,
                onPressed: queueState.hasNext
                    ? audioHandler.skipToNext
                    : () => print("no next"),
              );
            },
          ),
        ]);
  }
}

class ArtWorkWidget extends StatefulWidget {
  final MediaItem mediaItem;
  final bool offline;
  final double width;

  const ArtWorkWidget(this.mediaItem, this.width, {this.offline = false});

  @override
  _ArtWorkWidgetState createState() => _ArtWorkWidgetState();
}

class _ArtWorkWidgetState extends State<ArtWorkWidget> {
  final ValueNotifier<bool> dragging = ValueNotifier<bool>(false);
  final ValueNotifier<bool> done = ValueNotifier<bool>(false);
  Map lyrics = {'id': '', 'lyrics': ''};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.width * 0.9,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: widget.width * 0.85,
          width: widget.width * 0.85,
          child: Hero(
            tag: 'currentArtwork',
            child: Container(
              child: StreamBuilder<QueueState>(
                  stream: audioHandler.queueState,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data ?? QueueState.empty;
                    return GestureDetector(
                      onTap: () {
                        audioHandler.playbackState.value.playing
                            ? audioHandler.pause()
                            : audioHandler.play();
                      },
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if ((details.primaryVelocity ?? 0) > 100) {
                          if (queueState.hasPrevious) {
                            audioHandler.skipToPrevious();
                          }
                        }

                        if ((details.primaryVelocity ?? 0) < -100) {
                          if (queueState.hasNext) {
                            audioHandler.skipToNext();
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade300,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3.0,
                                  offset: Offset(1, 1),
                                  // shadow direction: bottom right
                                )
                              ],
                            ),
                            //elevation: 10.0,
                            /*shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.hardEdge,*/
                            child: widget.mediaItem.artUri
                                    .toString()
                                    .startsWith('file')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        height: widget.width * 0.85,
                                        width: widget.width * 0.85,
                                        gaplessPlayback: true,
                                        image: FileImage(File(widget
                                            .mediaItem.artUri
                                            .toFilePath()))),
                                  )
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    errorWidget:
                                        (BuildContext context, _, __) =>
                                            const Image(
                                      image: AssetImage('assets/cover.jpg'),
                                    ),
                                    placeholder: (BuildContext context, _) =>
                                        const Image(
                                      image: AssetImage('assets/cover.jpg'),
                                    ),
                                    imageUrl:
                                        widget.mediaItem.artUri.toString(),
                                    height: widget.width * 0.85,
                                  ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: dragging,
                              builder: (BuildContext context, bool value,
                                  Widget child) {
                                return Visibility(
                                  visible: value,
                                  child: StreamBuilder<double>(
                                      stream: audioHandler.volume,
                                      builder: (context, snapshot) {
                                        final double volumeValue =
                                            snapshot.data ?? 1.0;
                                        return Center(
                                          child: SizedBox(
                                            width: 60.0,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Card(
                                              color: Colors.black87,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: RotatedBox(
                                                        quarterTurns: -1,
                                                        child: SliderTheme(
                                                          data: SliderTheme.of(
                                                                  context)
                                                              .copyWith(
                                                            //thumbShape: HiddenThumbComponentShape(),
                                                            activeTrackColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                            inactiveTrackColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary
                                                                    .withOpacity(
                                                                        0.4),
                                                            trackShape:
                                                                const RoundedRectSliderTrackShape(),
                                                          ),
                                                          child:
                                                              ExcludeSemantics(
                                                            child: Slider(
                                                              value:
                                                                  audioHandler
                                                                      .volume
                                                                      .value,
                                                              onChanged: (_) {},
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20.0),
                                                    child: Icon(volumeValue == 0
                                                        ? Icons
                                                            .volume_off_rounded
                                                        : volumeValue > 0.6
                                                            ? Icons
                                                                .volume_up_rounded
                                                            : Icons
                                                                .volume_down_rounded),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class NameNControls extends StatelessWidget {
  final MediaItem mediaItem;
  final bool offline;
  final bool displayNowPlaying;

  const NameNControls(this.mediaItem,
      {this.offline = false, @required this.displayNowPlaying});

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<Duration> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /// Title and subtitle
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// Title container
                  Text(
                    mediaItem.title.split(' (')[0].split('|')[0].trim(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).accentColor,
                    ),
                  ),

                  const SizedBox(height: 3.0),

                  /// Subtitle container
                  Text(
                    mediaItem.artist ?? 'Unknown',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Seekbar starts from here

        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data ??
                PositionData(Duration.zero, Duration.zero,
                    mediaItem.duration ?? Duration.zero);
            return SeekBar(
              duration: positionData.duration,
              position: positionData.position,
              bufferedPosition: positionData.bufferedPosition,
              onChangeEnd: (newPosition) {
                audioHandler.seek(newPosition);
              },
            );
          },
        ),

        /// Final row starts from here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 6.0),
                  StreamBuilder<bool>(
                    stream: audioHandler.playbackState
                        .map((state) =>
                            state.shuffleMode == AudioServiceShuffleMode.all)
                        .distinct(),
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? const Icon(
                                Icons.shuffle_rounded,
                                color: Colors.white,
                              )
                            : Icon(Icons.shuffle_rounded,
                                color: Colors.white.withOpacity(0.5)),
                        tooltip: 'Shuffle',
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          await audioHandler.setShuffleMode(enable
                              ? AudioServiceShuffleMode.all
                              : AudioServiceShuffleMode.none);
                        },
                      );
                    },
                  ),
                ],
              ),
              ControlButtons(audioHandler),
              Column(
                children: [
                  const SizedBox(height: 6.0),
                  StreamBuilder<AudioServiceRepeatMode>(
                    stream: audioHandler.playbackState
                        .map((state) => state.repeatMode)
                        .distinct(),
                    builder: (context, snapshot) {
                      final repeatMode =
                          snapshot.data ?? AudioServiceRepeatMode.none;
                      const texts = ['None', 'All', 'One'];
                      final icons = [
                        Icon(Icons.repeat_rounded,
                            color: Colors.white.withOpacity(0.5)),
                        const Icon(
                          Icons.repeat_rounded,
                          color: Colors.white,
                        ),
                        const Icon(Icons.repeat_one_rounded,
                            color: Colors.white),
                      ];
                      const cycleModes = [
                        AudioServiceRepeatMode.none,
                        AudioServiceRepeatMode.all,
                        AudioServiceRepeatMode.one,
                      ];
                      final index = cycleModes.indexOf(repeatMode);
                      return IconButton(
                        icon: icons[index],
                        tooltip: 'Repeat ${texts[(index + 1) % texts.length]}',
                        onPressed: () {
                          audioHandler.setRepeatMode(cycleModes[
                              (cycleModes.indexOf(repeatMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Now playing
        displayNowPlaying
            ? GestureDetector(
                onVerticalDragEnd: (_) {
                  print("show modal bottom sheet");
                },
                onTap: () {
                  print("show modal bottom sheet");
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 5.0),
                    Icon(
                      Icons.expand_less_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
