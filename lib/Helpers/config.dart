library config.globals;

import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  bool _isDark = true;

  int backGrad = 1;
  int bottomGrad = 2;
  int cardGrad = 3;

  List<List<Color>> backOpt = [
    [
      Colors.grey[850],
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.black,
      Colors.black,
    ],
    [
      Colors.black,
      Colors.black,
    ]
  ];

  List<List<Color>> cardOpt = [
    [
      Colors.grey[850],
      Colors.grey[850],
      Colors.grey[900],
    ],
    [
      Colors.grey[850],
      Colors.grey[900],
      Colors.grey[900],
    ],
    [
      Colors.grey[850],
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.black,
    ],
    [
      Colors.grey[900],
      Colors.black,
      Colors.black,
    ],
    [
      Colors.black,
      Colors.black,
    ]
  ];

  List<List<Color>> transOpt = [
    [
      Colors.grey[850].withOpacity(0.8),
      Colors.grey[900].withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900].withOpacity(0.8),
      Colors.grey[900].withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900].withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.grey[900].withOpacity(0.9),
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ],
    [
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(1),
    ]
  ];

  void switchTheme({@required bool isDark}) {
    _isDark = isDark;
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  List<Color> getCardGradient({bool miniplayer = false}) {
    final List<Color> output = cardOpt[cardGrad];
    if (miniplayer && output.length > 2) {
      output.removeAt(0);
    }
    return output;
  }

  List<Color> getTransBackGradient() {
    return transOpt[backGrad];
  }

  List<Color> getBottomGradient() {
    return backOpt[bottomGrad];
  }

  List<Color> getBackGradient() {
    return backOpt[backGrad];
  }

  Color getPlayGradient() {
    return backOpt[backGrad].last;
  }

  Color getColor(String color, int hue) {
    switch (color) {
      case 'Red':
        return Colors.redAccent[hue];
      case 'Teal':
        return Colors.tealAccent[hue];
      case 'Light Blue':
        return Colors.lightBlueAccent[hue];
      case 'Yellow':
        return Colors.yellowAccent[hue];
      case 'Orange':
        return Colors.orangeAccent[hue];
      case 'Blue':
        return Colors.blueAccent[hue];
      case 'Cyan':
        return Colors.cyanAccent[hue];
      case 'Lime':
        return Colors.limeAccent[hue];
      case 'Pink':
        return Colors.pinkAccent[hue];
      case 'Green':
        return Colors.greenAccent[hue];
      case 'Amber':
        return Colors.amberAccent[hue];
      case 'Indigo':
        return Colors.indigoAccent[hue];
      case 'Purple':
        return Colors.purpleAccent[hue];
      case 'Deep Orange':
        return Colors.deepOrangeAccent[hue];
      case 'Deep Purple':
        return Colors.deepPurpleAccent[hue];
      case 'Light Green':
        return Colors.lightGreenAccent[hue];
      case 'White':
        return Colors.white;

      default:
        return _isDark ? Colors.tealAccent[400] : Colors.lightBlueAccent[400];
    }
  }
}

MyTheme currentTheme = MyTheme();
