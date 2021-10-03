import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

double currentSlider = 0;

class PlayerHome extends StatefulWidget {
  final SongInfo song;
  PlayerHome(this.song);

  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> {
  Duration duration = Duration();
  @override
  void initState() {
    super.initState();
    if (widget.song != null) {
      duration = Duration(milliseconds: int.parse(widget.song.duration));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pressed");
      },
      child: Container(
        height: 130,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "image",
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/no_cover.png"),
                        radius: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.song != null
                            ? Text(widget.song.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                            : Text(""),
                        widget.song != null
                            ? Text(widget.song.artist,
                                style: TextStyle(
                                  color: Colors.white54,
                                ))
                            : Text("")
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.pause, color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.skip_next_outlined,
                        color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Duration(seconds: currentSlider.toInt())
                      .toString()
                      .split('.')[0]
                      .substring(2),
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: currentSlider,
                      max: duration.inSeconds.toDouble(),
                      min: 0,
                      inactiveColor: Colors.grey[500],
                      activeColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          currentSlider = val;
                        });
                      },
                    ),
                  ),
                ),
                widget.song != null
                    ? Text(
                        Duration(milliseconds: int.parse(widget.song.duration))
                            .toString()
                            .split('.')[0]
                            .substring(2),
                        style: TextStyle(color: Colors.white),
                      )
                    : Text('')
              ],
            )
          ],
        ),
      ),
    );
  }
}
