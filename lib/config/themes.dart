import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class App {
  static ThemeData theme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Raleway',
    primaryColor: AppColors.white,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.orange,
    ),
  );
}

class AppColors {
  ///
  static Color appGradientDefaultColorBlack = HexColor('#95999d');
  static Color appGradientDefaultColor = HexColor('#1E96ED');

  ///PRIMARY COLORS
  static Color orange = HexColor('#E9571C');
  static Color darkOrange = HexColor('#E7481B');

  ///LIGHT COLORS
  static Color white = HexColor('#FFFFFF');
  static Color lightGrey = HexColor('#EAEAEA'); //e9e9e9
  static Color pagesBgColor = HexColor("#F8F8F8"); //fbfbfb
  static Color placeholderIconColor = HexColor("#BEBEC5");

  ///DARK COLORS
  static Color darkGrey = HexColor('#3C3C3C');
  static Color txtGrey = HexColor('#8b8b8b');
  static Color grey = HexColor('#88898D');
  static Color black = HexColor('#121212');

  ///SECONDARY COLORS
  static Color blue = HexColor('#1E96ED');
  static Color errorRed = Colors.redAccent;
  static Color yellow = HexColor('#f7c631');

  static Color transparent = Colors.transparent;

  ///FOR GRADIENT PURPOSES
  static Color orange1 = HexColor('#EC8E20');
  static Color orange2 = HexColor('#E9591C');
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
  static const double padding_24 = 24;
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
