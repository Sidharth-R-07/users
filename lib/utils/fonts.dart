import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class FontsProvider {
  static TextStyle titleLarge = GoogleFonts.playfairDisplay(
      color: primaryColor, fontSize: 35, fontWeight: FontWeight.bold);
  static TextStyle titleMedium = GoogleFonts.playfairDisplay(
      color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold);

  static TextStyle hintText =
      GoogleFonts.mukta(fontSize: 18, color: Colors.grey);
  static TextStyle errorText =
      GoogleFonts.mukta(fontSize: 14, color: Colors.red);
  static TextStyle whiteMediumText =
      GoogleFonts.mukta(fontSize: 24, color: bgScaffold);
}
