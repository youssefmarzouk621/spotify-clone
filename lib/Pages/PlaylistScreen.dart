import 'package:flutter/material.dart';
import 'package:music_player/CustomWidgets/TextInputDialog.dart';
import 'package:music_player/MiniPlayer.dart';
import 'package:music_player/Models/PlaylistModel.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<HNPlaylistModel> list = [];
  Map playlistDetails = {};
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              title: const Text(
                'Playlists',
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
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
                            list.add(new HNPlaylistModel(
                                dateCreated: DateTime.now(),
                                title: value,
                                songs: [],
                                duration: 0));
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
                          final HNPlaylistModel playlist = list[index];
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
                              playlist.title,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${playlist.songs.length} Songs',
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
                              onSelected: (int value) {},
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 3,
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
                                  value: 0,
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
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.import_export,
                                          color: Colors.white),
                                      SizedBox(width: 10.0),
                                      Text('Export',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.share, color: Colors.white),
                                      SizedBox(width: 10.0),
                                      Text('Share',
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
          ),
        ),
        MiniPlayer(),
      ],
    );
  }
}
