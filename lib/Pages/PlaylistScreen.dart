import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/CustomWidgets/TextInputDialog.dart';
import 'package:music_player/CustomWidgets/empty_screen.dart';
import 'package:music_player/CustomWidgets/snackbar.dart';
import 'package:music_player/Helpers/audio_query.dart';
import 'package:music_player/MiniPlayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Box playlistsBox = Hive.box('playlists');
  List<Map<String, dynamic>> list = [];

  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  bool added = false;

  @override
  void initState() {
    super.initState();
  }

  bool containsPlaylist(List<Map<String, dynamic>> playlists, String value) {
    bool exist = false;
    for (var i = 0; i < playlists.length; i++) {
      if (playlists[i]["title"] == value) {
        exist = true;
      }
    }
    return exist;
  }

  @override
  Widget build(BuildContext context) {
    list = (playlistsBox.get('playlists') == null ||
            playlistsBox.get('playlists').length == 0)
        ? []
        : playlistsBox.get('playlists').toList() as List;
    print(list);
    //playlistsBox.put('playlists', list);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Playlists',
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  ListTile(
                    title: const Text('Create Playlist',
                        style: TextStyle(color: Colors.white)),
                    leading: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await TextInputDialog().showTextInputDialog(
                          context: context,
                          title: 'Create New playlist',
                          initialText: '',
                          keyboardType: TextInputType.name,
                          onSubmitted: (String value) {
                            if (value.trim() == '') {
                              value = 'Playlist ${list.length}';
                            }
                            if (containsPlaylist(list, value)) {
                              print("exist");
                            } else {
                              list.add({
                                "dateCreated": DateTime.now(),
                                "title": value,
                                "songs": [],
                                "duration": 0
                              });

                              playlistsBox.put('playlists', list);
                            }

                            Navigator.pop(context);
                          });
                      setState(() {});
                    },
                  ),
                  if (list.isEmpty)
                    const SizedBox()
                  else
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> playlist = list[index];
                          return ListTile(
                            leading: Card(
                              elevation: 5,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: const Image(
                                    image: AssetImage('assets/album.png')),
                              ),
                            ),
                            /*Collage(
                                  imageList: playlistDetails[name]
                                      ['imagesList'] as List,
                                  placeholderImage: 'assets/cover.jpg'),multiple images */
                            title: Text(
                              playlist["title"],
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${playlist["songs"].length} Songs',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: PopupMenuButton(
                              color: Colors.black26,
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                              ),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              onSelected: (int value) {
                                if (value == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final _controller = TextEditingController(
                                          text: playlist["title"]);
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Rename',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              autofocus: true,
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              controller: _controller,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              playlist.addAll({
                                                "title": _controller.text.trim()
                                              });
                                              list[index] = playlist;
                                              setState(() {});
                                            },
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .colorScheme
                                                              .secondary ==
                                                          Colors.white
                                                      ? Colors.black
                                                      : null),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                if (value == 2) {
                                  ShowSnackBar().showSnackBar(
                                    context,
                                    'Deleted ' + playlist["title"],
                                  );

                                  list.removeAt(index);
                                  playlistsBox.put('playlists', list);
                                  setState(() {});
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit_rounded,
                                          color: Colors.white),
                                      SizedBox(width: 10.0),
                                      Text('Rename',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete_rounded,
                                          color: Colors.white),
                                      SizedBox(width: 10.0),
                                      Text('Delete',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          );
                        })
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: MiniPlayer())),
          ],
        ));
  }
}

class PlaylistsTab extends StatelessWidget {
  final List<SongModel> cachedSongs;
  final List cachedSongsMap;
  const PlaylistsTab(
      {@required this.cachedSongs, @required this.cachedSongsMap});

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
                selectedTileColor: Colors.red,
                selected: true,
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
                onTap: () {
                  print(cachedSongs[index].id.toString() +
                      " :" +
                      cachedSongs[index].title +
                      " by" +
                      cachedSongs[index].artist);
                },
              );
            });
  }
}
