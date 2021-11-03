import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/fake_data.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorUtil {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color changeColorHue(Color color, double newHueValue) =>
      HSLColor.fromColor(color).withHue(newHueValue).toColor();

  static Color changeColorSaturation(Color color, double newSaturationValue) =>
      HSLColor.fromColor(color).withSaturation(newSaturationValue).toColor();

  static Color changeColorLightness(Color color, double newLightnessValue) =>
      HSLColor.fromColor(color).withLightness(newLightnessValue).toColor();

  // static Future<Color> getDarkImagePalette(ImageProvider imageProvider) async {
  //   final PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(imageProvider);
  //   if (paletteGenerator.darkVibrantColor != null) {
  //     print("${AppTestValues.debugTxt} darkVibrantColor");
  //     return paletteGenerator.darkVibrantColor!.color;
  //   } else if (paletteGenerator.darkMutedColor != null) {
  //     print("${AppTestValues.debugTxt} darkMutedColor");
  //     return paletteGenerator.darkMutedColor!.color;
  //   } else if (paletteGenerator.mutedColor != null) {
  //     print("${AppTestValues.debugTxt} mutedColor");
  //     return paletteGenerator.mutedColor!.color;
  //   } else if (paletteGenerator.dominantColor != null) {
  //     print("${AppTestValues.debugTxt} dominantColor");
  //     return paletteGenerator.dominantColor!.color;
  //   } else if (paletteGenerator.vibrantColor != null) {
  //     print("${AppTestValues.debugTxt} vibrantColor");
  //     return paletteGenerator.vibrantColor!.color;
  //   } else if (paletteGenerator.lightMutedColor != null) {
  //     print("${AppTestValues.debugTxt} lightMutedColor");
  //     return paletteGenerator.lightMutedColor!.color;
  //   } else if (paletteGenerator.lightVibrantColor != null) {
  //     print("${AppTestValues.debugTxt} lightVibrantColor");
  //     return paletteGenerator.lightVibrantColor!.color;
  //   } else {
  //     print("${AppTestValues.debugTxt} appGradientDefaultColor");
  //     return AppColors.appGradientDefaultColor;
  //   }
  // }

  static ImageProvider? getImageProvider(String url) {
    try {
      final ImageProvider imageProvider = CachedNetworkImageProvider(
        url,
        errorListener: () {
          return null;
        },
      );
      return imageProvider;
    } catch (e) {
      return null;
    }
  }

  // static Future<Color> getLightImagePalette(ImageProvider imageProvider) async {
  //   final PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(imageProvider);
  //   if (paletteGenerator.vibrantColor != null) {
  //     print("${AppTestValues.debugTxt} vibrantColor");
  //     return paletteGenerator.vibrantColor!.color;
  //   } else if (paletteGenerator.lightMutedColor != null) {
  //     print("${AppTestValues.debugTxt} lightMutedColor");
  //     return paletteGenerator.lightMutedColor!.color;
  //   } else if (paletteGenerator.lightVibrantColor != null) {
  //     print("${AppTestValues.debugTxt} lightVibrantColor");
  //     return paletteGenerator.vibrantColor!.color;
  //   } else if (paletteGenerator.mutedColor != null) {
  //     print("${AppTestValues.debugTxt} mutedColor");
  //     return paletteGenerator.mutedColor!.color;
  //   } else if (paletteGenerator.dominantColor != null) {
  //     print("${AppTestValues.debugTxt} dominantColor");
  //     return paletteGenerator.dominantColor!.color;
  //   } else if (paletteGenerator.darkMutedColor != null) {
  //     print("${AppTestValues.debugTxt} darkMutedColor");
  //     return paletteGenerator.darkMutedColor!.color;
  //   } else if (paletteGenerator.darkVibrantColor != null) {
  //     print("${AppTestValues.debugTxt} darkVibrantColor");
  //     return paletteGenerator.darkVibrantColor!.color;
  //   } else {
  //     print("${AppTestValues.debugTxt} appGradientDefaultColor");
  //     return AppColors.appGradientDefaultColor;
  //   }
  // }
  //
  // static Future<Color> getPalette(ImageProvider imageProvider) async {
  //   final PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(imageProvider);
  //   return paletteGenerator.dominantColor!.color;
  // }
}
