import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class App {
  static ThemeData theme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "Poppins",
    primaryColor: AppColors.black,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.green,
    ),
  );
}

class AppColors {
  static Color appGradientDefaultColorBlack = HexColor("#95999d");
  static Color appGradientDefaultColor = HexColor("#1E96ED");
  static Color green = HexColor("#27D660");
  static Color darkGreen = HexColor("#1db954");
  static Color black = HexColor("#121212");
  static Color completelyBlack = HexColor("#000000");
  static Color lightGrey = HexColor("#DFE0E5");
  static Color txtGrey = HexColor("#a5a6ab");
  static Color grey = HexColor("#88898D");
  static Color darkGrey = HexColor("#333333");
  static Color white = HexColor("#ffffff");
  static Color transparent = Colors.transparent;
  static Color blue = HexColor("#1E96ED");
  static Color errorRed = Colors.redAccent;
  static Color yellow = HexColor("#f7c631");

  ///HOME LIBRARY BUTTONS
  static Color orange1 = HexColor("#E8A14D");
  static Color orange2 = HexColor("#FF7C3E");
  static Color orange3 = HexColor("#E57343");
  static Color blue1 = HexColor("#66C7C5");
  static Color blue2 = HexColor("#4997CB");
  static Color blue3 = HexColor("#5C91EF");
}

class AppFontSizes {
  static const double font_size_8 = 8;
  static const double font_size_10 = 10;
  static const double font_size_12 = 12;
  static const double font_size_14 = 14;
  static const double font_size_16 = 16;
  static const double font_size_18 = 18;
  static const double font_size_20 = 20;
  static const double font_size_22 = 22;
  static const double font_size_24 = 24;
  static const double font_size_28 = 28;
  static const double font_size_42 = 42;
  static const double font_size_32 = 32;
  static const double font_size_6 = 6;
}

class AppPadding {
  static const double padding_6 = 6;
  static const double padding_8 = 8;
  static const double padding_16 = 16;
  static const double padding_20 = 20;
  static const double padding_28 = 28;
  static const double padding_32 = 32;
  static const double padding_12 = 12;
  static const double padding_14 = 14;
  static const double padding_4 = 4;
  static const double padding_2 = 2;
  static const double padding_18 = 18;
}

class AppMargin {
  static const double margin_4 = 4;
  static const double margin_6 = 6;
  static const double margin_8 = 8;
  static const double margin_16 = 16;
  static const double margin_20 = 20;
  static const double margin_28 = 28;
  static const double margin_32 = 32;
  static const double margin_38 = 38;
  static const double margin_48 = 48;
  static const double margin_52 = 52;
  static const double margin_58 = 58;
  static const double margin_2 = 2;
  static const double margin_12 = 12;
  static const double margin_62 = 62;
  static const double margin_24 = 24;
}

class AppCardElevations {
  static const double elevation_6 = 6;
  static const double elevation_8 = 8;
  static const double elevation_12 = 12;
  static const double elevation_16 = 16;
  static const double elevation_20 = 20;
}
