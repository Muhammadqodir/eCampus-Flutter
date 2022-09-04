import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomColors {
  static Color success = HexColor.fromHex("#27AE60");
  static Color warning = HexColor.fromHex("#E4B90E");
  static Color error = HexColor.fromHex("#E74C3C");

  static Color perfect = HexColor.fromHex("#20AA49");
  static Color good = HexColor.fromHex("#AEDE1B");
  static Color satisfactorily = HexColor.fromHex("#F67A25");
  static Color unsatisfactorily = HexColor.fromHex("#E51A22");

  static List<Color> grades = [perfect, good, satisfactorily, unsatisfactorily];

  static List<Color> colorPalette = [
    HexColor.fromHex("#009AD1"),
    HexColor.fromHex("#f77f00"),
    HexColor.fromHex("#ef233c"),
    HexColor.fromHex("#ac685d"),
    HexColor.fromHex("#85888C"),
    HexColor.fromHex("#324445"),
    HexColor.fromHex("#009352"),
  ];
}
