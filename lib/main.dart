import 'package:flutter/material.dart';
import 'package:music_player/Statics/Statics.dart';
import 'package:music_player/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeLightData(context),
      darkTheme: themeDarkData(context),
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
