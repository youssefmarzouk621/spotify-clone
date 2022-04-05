import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/CustomWidgets/empty_screen.dart';
import 'package:music_player/Helpers/audio_query.dart';
import 'package:music_player/MiniPlayer.dart';
import 'package:music_player/MusicPlayer.dart';
import 'package:music_player/Statics/Statics.dart';

import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> with AutomaticKeepAliveClientMixin {
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  List<SongModel> _cachedSongs = [];
  List<dynamic> _cachedSongsMap = [];

  bool added = false;
  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    await Future.delayed(Duration(milliseconds: 300));
    await offlineAudioQuery.requestPermission();
    final List<SongModel> temp = await offlineAudioQuery.getSongs();

    _cachedSongs =
        temp.where((i) => (i.duration ?? 60000) > 1000 * 10).toList();
    added = true;
    setState(() {});
    _cachedSongsMap = await offlineAudioQuery.getArtwork(_cachedSongs);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Songs'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
        centerTitle: false,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          !added
              ? Container(
                  child: Center(
                    child: Container(
                        height: MediaQuery.of(context).size.width / 7,
                        width: MediaQuery.of(context).size.width / 7,
                        child: LoadingAnimation()),
                  ),
                )
              : SongsTab(
                  cachedSongs: _cachedSongs,
                  cachedSongsMap: _cachedSongsMap,
                ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: MiniPlayer())),
        ],
      ),
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

/*  Widget _buildImage(SongInfo songInfo) {
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
*/
  @override
  bool get wantKeepAlive => true;
}

class SongsTab extends StatelessWidget {
  final List<SongModel> cachedSongs;
  final List cachedSongsMap;
  const SongsTab({@required this.cachedSongs, @required this.cachedSongsMap});
  Route playScreenRoute(
      {Map<dynamic, dynamic> data,
      bool fromMiniplayer,
      bool displayNowPlaying}) {
    return PageRouteBuilder(
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
    return cachedSongs.isEmpty
        ? EmptyScreen().emptyScreen(context, 3, 'Nothing to ', 15.0,
            'Show Here', 45, 'Download Something', 23.0)
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            shrinkWrap: true,
            itemExtent: 70.0,
            itemCount: cachedSongs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: QueryArtworkWidget(
                  id: cachedSongs[index].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(7.0),
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: const Image(
                      fit: BoxFit.cover,
                      height: 50.0,
                      width: 50.0,
                      image: AssetImage('assets/cover.jpg'),
                    ),
                  ),
                ),
                title: Text(
                  cachedSongs[index].title.trim() != ''
                      ? cachedSongs[index].title
                      : cachedSongs[index].displayNameWOExt,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).textSelectionColor),
                ),
                subtitle: Text(
                  cachedSongs[index]
                          .artist
                          ?.replaceAll('<unknown>', 'Unknown') ??
                      'Unknown',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).textSelectionColor),
                ),
                trailing: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    onSelected: (int value) async {
                      if (value == 0) {
                        /*AddToOffPlaylist().addToOffPlaylist(
                              context,
                              widget.songs[index].id,
                            );*/
                      }
                      if (value == 1) {
                        /*await OfflineAudioQuery().removeFromPlaylist(
                              playlistId: widget.playlistId!,
                              audioId: widget.songs[index].id,
                            );
                            ShowSnackBar().showSnackBar(
                              context,
                              '${AppLocalizations.of(context)!.removedFrom} ${widget.playlistName}',
                            );*/
                      }
                    },
                    //color: Colors.green,
                    color: Colors.grey[900],
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                const Icon(Icons.playlist_add_rounded,
                                    color: Colors.white),
                                const SizedBox(width: 10.0),
                                Text(
                                  "add to playlist",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ]),
                onTap: () async {
                  final int playIndex = cachedSongsMap.indexWhere(
                      (element) => element['_id'] == cachedSongs[index].id);

                  if (playIndex == -1) {
                    final singleSongMap = await OfflineAudioQuery()
                        .getArtwork([cachedSongs[index]]);
                    Navigator.of(context).push(playScreenRoute(data: {
                      'response': singleSongMap,
                      'index': 0,
                      'offline': true
                    }, fromMiniplayer: false, displayNowPlaying: false));
                  } else {
                    Navigator.of(context).push(playScreenRoute(
                      data: {
                        'response': cachedSongsMap,
                        'index': playIndex,
                        'offline': true
                      },
                      fromMiniplayer: false,
                      displayNowPlaying: false,
                    ));
                  }
                },
              );
            });
  }
}
