import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TThemedata {
  static const green = Color(0xFF38E54D);
  static const red = Color(0xFFDD5353);
  static const purpel = Color(0xFF372948);
  static const grey = Color.fromARGB(255, 104, 103, 103);
  static Widget text(data, clr) {
    return Text(
      data,
      style: GoogleFonts.openSans(
          color: clr, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  static Widget desc(data, clr) {
    return Text(
      data,
      overflow: TextOverflow.clip,
      style: GoogleFonts.openSans(
          color: clr, fontWeight: FontWeight.w500, fontSize: 15),
    );
  }

  static Widget profile(data, clr) {
    return Text(
      data,
      overflow: TextOverflow.clip,
      style: GoogleFonts.openSans(
        color: clr,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    );
  }

  static title() {
    return Container();
  }
}
