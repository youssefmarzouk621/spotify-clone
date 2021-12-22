import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/Pages/Artist.dart';
import 'package:music_player/Pages/PlaylistScreen.dart';
import 'package:music_player/Pages/Songs.dart';
import 'package:music_player/MiniPlayer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          // child: DefaultTabController(
          // length: 4,
          child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.only(left: 10),
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Library",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 27,
                          fontWeight: FontWeight.bold)),
                  titlePadding: EdgeInsets.only(left: 15, bottom: 10),
                ),
                brightness: Brightness.dark,
                backgroundColor: Theme.of(context).backgroundColor,
                toolbarHeight: 60,
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _buildPages(),
                Container(
                    padding: EdgeInsets.only(top: 15),
                    child: _buildFavotitesArtists()),

                //_buildRecentlyAdded(),
              ]))
            ],
          ),
        ),
      )),
      MiniPlayer()
    ]);
  }

  Widget _buildRecentlyAdded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Recently Added",
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 25,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildFavotitesArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Your Favorites Artists",
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: _buildArtistCard(
                      artistName: "Kid Cudi", imagePath: "assets/kidcudi.jpeg"),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: _buildArtistCard(
                      artistName: "Dua Lipa", imagePath: "assets/dualipa.jpeg"),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: _buildArtistCard(
                      artistName: "Rihanna", imagePath: "assets/rihanna.jpg"),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: _buildArtistCard(
                      artistName: "ElGrandeToto",
                      imagePath: "assets/grandetoto.jpeg"),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: _buildArtistCard(
                      artistName: "Drake", imagePath: "assets/drake.png"),
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildArtistCard({String artistName, String imagePath}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Artist(
                      ArtistName: artistName,
                      imagePath: imagePath,
                    )));
      },
      child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              alignment: AlignmentDirectional.center,
            ),
          )),
    );
  }

  Widget _buildPages() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildChoiceCard(
              text: "Playlists",
              icon: CupertinoIcons.music_note_list,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlaylistScreen()));
              }),
          _buildChoiceCard(
              text: "Artistes",
              icon: CupertinoIcons.music_mic,
              onPressed: () {
                print("preesed");
              }),
          _buildChoiceCard(
              text: "Albums",
              icon: CupertinoIcons.music_albums,
              onPressed: () async {
                /*await Future.delayed(Duration(milliseconds: 100));

                List<AlbumInfo> albums = await audioQuery.getAlbums();
                albums = albums
                    .where((album) =>
                        (album.title != "Music" && album.numberOfSongs != "1"))
                    .toList();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Albums(
                              albums: albums,
                            )));*/
              }),
          _buildChoiceCard(
              text: "Songs",
              icon: CupertinoIcons.music_note,
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Songs()));
              })
        ],
      ),
    );
  }

  Widget _buildChoiceCard({String text, IconData icon, Function onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 0.5,
        color: Theme.of(context).backgroundColor,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
