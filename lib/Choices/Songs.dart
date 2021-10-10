import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/CustomWidgets/empty_screen.dart';
import 'package:music_player/CustomWidgets/gradient_containers.dart';
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
    getCached();
  }

  Future<void> getCached() async {
    await Future.delayed(Duration(milliseconds: 500));
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
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            // child: DefaultTabController(
            // length: 4,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: const Text('Songs'),
                // bottom: TabBar(
                // controller: _tcontroller,
                // tabs:
                // widget.type == 'all'
                // ?
                //  [
                //     const Tab(
                //       text: 'Songs',
                //     ),
                //     const Tab(
                //       text: 'Albums',
                //     ),
                //     const Tab(
                //       text: 'Artists',
                //     ),
                //     const Tab(
                //       text: 'Genres',
                //     ),
                //     const Tab(
                //       text: 'Videos',
                //     )
                //   ]
                // :
                // const [
                // Tab(
                //   text: 'Songs',
                // ),
                // Tab(
                //   text: 'Albums',
                // ),
                // Tab(
                //   text: 'Artists',
                // ),
                // Tab(
                //   text: 'Genres',
                // ),
                // ],
                // ),
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
              body: !added
                  ? SizedBox(
                      child: Center(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.width / 7,
                            width: MediaQuery.of(context).size.width / 7,
                            child: LoadingAnimation()),
                      ),
                    )
                  :
                  // TabBarView(
                  //     physics: const CustomPhysics(),
                  //     controller: _tcontroller,
                  //     children:
                  //         //  widget.type == 'all'
                  //         //     ?
                  //         [
                  SongsTab(
                      cachedSongs: _cachedSongs,
                      cachedSongsMap: _cachedSongsMap,
                    ),
            ),
          ),
          MiniPlayer(),
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
                onTap: () async {
                  final int playIndex = cachedSongsMap.indexWhere(
                      (element) => element['_id'] == cachedSongs[index].id);
                  if (playIndex == -1) {
                    final singleSongMap = await OfflineAudioQuery()
                        .getArtwork([cachedSongs[index]]);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => PlayScreen(
                          data: {
                            'response': singleSongMap,
                            'index': 0,
                            'offline': true
                          },
                          fromMiniplayer: false,
                          displayNowPlaying: false,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => PlayScreen(
                          data: {
                            'response': cachedSongsMap,
                            'index': playIndex,
                            'offline': true
                          },
                          fromMiniplayer: false,
                          displayNowPlaying: false,
                        ),
                      ),
                    );
                  }
                },
              );
            });
  }
}
