import 'package:flutter/material.dart';

class ManagerFontStyles {

  //    Hearder text : 25
  //    button text : 20
  //    label text : 20
  //    description text : 18

  static const double hearderSize  = 32.0;
  static const double labelSize = 26.0;
  static const double buttonSize = 26.0;
  static const double decriptionSize = 22.0;
  static const double defualtSize = 24.0;


  static const FontWeight fwLight = FontWeight.w400;
  static const FontWeight fwRegular = FontWeight.w500;
  static const FontWeight fwMedium = FontWeight.w600;
  static const FontWeight fwBbold = FontWeight.w700;
  static const FontWeight fwBbold1 = FontWeight.w900;

  // hearder text Style bold
  static const TextStyle headerStyleBold = TextStyle(
    fontSize: hearderSize,
    fontWeight: fwBbold,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  // hearder text Style Regular
  static const TextStyle headerStyle = TextStyle(
    fontSize: hearderSize,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  // label text Style bold
  static const TextStyle labelStyleBold = TextStyle(
    fontSize: labelSize,
   fontWeight: fwBbold,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  // label text Style Regular
  static const TextStyle labelStyle = TextStyle(
    fontSize: labelSize,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  // button text Style Bold
  static const TextStyle buttonStyleBold = TextStyle(
    fontSize: buttonSize,
    color: Colors.white,
    fontWeight: fwBbold,
    fontFamily: "PatrickHandSC",
  );

  // button text Style Regular
  static const TextStyle buttonStyle = TextStyle(
    fontSize: buttonSize,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  // description text Style Bold
  static const TextStyle descriptionStyleBold = TextStyle(
    fontSize: decriptionSize,
    color: Colors.white,
    fontWeight: fwBbold,
    fontFamily: "PatrickHandSC",
  );

  // description text Style Regular
  static const TextStyle descriptionStyle = TextStyle(
    fontSize: decriptionSize,
    color: Colors.white,
    fontFamily: "PatrickHandSC",
  );

  

  // Customizable text style method
  static TextStyle custom({
    double fontSize = defualtSize,
    FontWeight fontWeight = fwRegular,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: "PatrickHandSC",
    );
  }
}

