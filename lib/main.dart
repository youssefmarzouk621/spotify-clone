import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/Services/audio_service.dart';
import 'package:music_player/Statics/Statics.dart';
import 'package:music_player/homePage.dart';
import 'package:music_player/MusicPlayer.dart';

AudioPlayerHandler audioHandler;
Future<void> main() async {
  await startService();
  runApp(MyApp());
}

Future<void> startService() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_player.channel.audio',
      androidNotificationChannelName: 'HighNote',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
      // androidStopForegroundOnPause: Hive.box('settings')
      // .get('stopServiceOnPause', defaultValue: true) as bool,
      notificationColor: Colors.grey[900],
    ),
  );
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
