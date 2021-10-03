import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String baseURL = "http://192.168.0.158:8080/Sirat-Fawateer/";
String baseUploadsURL =
    "http://192.168.0.158:8080/Sirat-Fawateer/uploads/"; //ressources route

DateFormat datetimeFormat = DateFormat("dd/MM/yyyy HH:mm");
DateFormat dateFormat = DateFormat("dd/MM/yyyy");

class Palette {
  static const Color iconColor = Color(0xffaabbcc);
  static const Color primaryColor = Color(0xff0678ea);
  static const Color secondaryColor = Color(0xff679de5);
  static const Color thirdColor = Color(0xff679de5);
  static const Color fourthColor = Color(0xff8fb9f1);

  static const Color textColor = Color(0xffffffff);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}



//Original Theme
ThemeData themeLightData(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme(
      Theme.of(context).textTheme,
    ),
    backgroundColor: Colors.white,
    textSelectionColor: Colors.black,
    textSelectionHandleColor : Colors.grey,
    shadowColor :Colors.grey[700],
    primaryColor: Colors.pinkAccent,
    accentColor: Color(0xff679de5),
    primaryColorDark: Color(0xff679de5),
    primaryColorLight: Color(0xfff7f9fb),
  );
}

ThemeData themeDarkData(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme(
      Theme.of(context).textTheme,
    ),
    backgroundColor: Colors.black,
    textSelectionColor: Colors.white,
    textSelectionHandleColor : Colors.grey,
    shadowColor :Colors.grey[700],
    primaryColor: Colors.pinkAccent,
    accentColor: Color(0xff679de5),
    primaryColorDark: Color(0xff679de5),
    primaryColorLight: Color(0xfff7f9fb),
  );
}