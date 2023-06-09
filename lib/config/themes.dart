import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/config/color_mapper.dart';

class App {
  static ThemeData theme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Raleway',
    //fontFamily: 'Poppins',
    primaryColor: ColorMapper.getWhite(),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: ColorMapper.getOrange(),
    ),
  );

  static var navigationKey = GlobalKey<NavigatorState>();
}

class AppAssets {
  ///APP ICONS
  static String icAppIconOnly = 'assets/icons/app_icons/ic_app_icon_only.png';
  static String icAppWordIcon = 'assets/icons/app_icons/ic_app_word_icon.png';
  static String icAppWordIconWhite =
      'assets/icons/app_icons/ic_app_word_icon_white.png';
  static String icAppLetterIconWhite =
      'assets/icons/app_icons/ic_app_letter_icon_white.png';
  static String icAppIconWhite = 'assets/icons/app_icons/ic_app_icon_white.png';
  static String icSplashIcon = 'assets/icons/app_icons/ic_splash_icon.png';
  static String isAppSmallIcon = 'assets/icons/app_icons/ic_app_icon_small.png';
  static String isAppSmallGreyIcon =
      'assets/icons/app_icons/ic_app_icon_small_grey.png';

  ///AUTH ICONS
  static String icApple = 'assets/icons/auth_icons/ic_apple.svg';
  static String icFacebook = 'assets/icons/auth_icons/ic_facebook.svg';
  static String icGoogle = 'assets/icons/auth_icons/ic_google.svg';
  static String icPhone = 'assets/icons/auth_icons/ic_phone.svg';

  ///PAYMENT ICONS
  static String icApplePay = 'assets/icons/payment_icons/ic_apple_pay.png';
  static String icAppleStore = 'assets/icons/payment_icons/ic_apple_store.png';
  // static String icCbe = 'assets/icons/payment_icons/ic_cbe.png';
  // static String icAmole = 'assets/icons/payment_icons/ic_amole.png';
  static String icGooglePlay = 'assets/icons/payment_icons/ic_google_play.png';
  static String icGooglePay = 'assets/icons/payment_icons/ic_google_pay.png';
  // static String icHelloCash = 'assets/icons/payment_icons/ic_hello_cash.png';
  // static String icMasterCard = 'assets/icons/payment_icons/ic_mastercard.png';
  // static String icMbirr = 'assets/icons/payment_icons/ic_mbirr.png';
  // static String icPaypal = 'assets/icons/payment_icons/ic_paypal.png';
  static String icTelebirr = 'assets/icons/payment_icons/ic_telebirr.png';
  static String icEthioTele = 'assets/icons/payment_icons/ic_ethio_tele.png';
  // static String icVisa = 'assets/icons/payment_icons/ic_visa.png';
  static String icYenepay = 'assets/icons/payment_icons/ic_yene_pay.png';
  // static String icDiscoveryCard =
  //     'assets/icons/payment_icons/ic_discovery_card.png';
  // static String icAmericanExpress =
  //     'assets/icons/payment_icons/ic_american_express.png';
  static String icCreditCards =
      'assets/icons/payment_icons/ic_credit_cards.png';

  ///IMAGES
  static String imageSignUpBg = 'assets/images/image_sign_up_bg.jpg';
  static String imageSubscribeCardBg =
      'assets/images/image_subscription_card_bg.png';
  static String imageEthioTeleLogo = 'assets/images/ethio_telecom_logo.png';

  ///LOTTIE FILES
  static String cartEmptyLottie = 'assets/lottie/cart_empty.json';
  static String loadingLottie = 'assets/lottie/loading.json';
  static String playingLottie = 'assets/lottie/playing.json';
  static String noInternetLottie = 'assets/lottie/no_internet.json';
  static String notificationGirlLottie = 'assets/lottie/notification_girl.json';
  static String notificationGiftLottie = 'assets/lottie/notification_gift.json';
  static String successLottie = 'assets/lottie/success.json';
  static String successLottieTwo = 'assets/lottie/success_two.json';
  static String cancelledLottie = 'assets/lottie/cancelled.json';
  static String cartStatusLottie = 'assets/lottie/cart_status.json';
  static String cartSuccessLottie = 'assets/lottie/cart_success.json';
  static String updateLottie = 'assets/lottie/update.json';
  static String subscriptionEndLottie = 'assets/lottie/subscription_end.json';
  static String subscriptionSuccessLottie =
      'assets/lottie/subscription_success.json';
  static String handPhoneLottie = 'assets/lottie/hand_phone.json';
}

class AppColors {
  ///FOR GRADIENT PURPOSES
  static Color orange1 = HexColor('#EBA027');
  static Color orange2 = HexColor('#E7491B');
  static Color green1 = HexColor('#47C172');
  static Color green2 = HexColor('#1ED05E');
  static Color appGradientDefaultColorBlack = HexColor('#95999d');
  static Color appGradientDefaultColor = HexColor('#1E96ED');

  ///PRIMARY COLORS
  static Color orange = HexColor('#ff6500'); //E9571C
  static Color darkOrange = HexColor('#e65100'); //E7481B
  static Color green = HexColor('#1DB352'); //E9571C
  static Color darkGreen = HexColor('#17A348'); //E7481B

  ///LIGHT COLORS
  static Color white = HexColor('#FFFFFF');
  static Color lightGrey = HexColor('#EAEAEA'); //e9e9e9
  static Color pagesBgColor = HexColor('#F8F8F8'); //fbfbfb
  static Color placeholderIconColor = HexColor('#BEBEC5');

  ///DARK COLORS
  static Color darkGrey = HexColor('#3C3C3C');
  static Color txtGrey = HexColor('#8b8b8b');
  static Color grey = HexColor('#88898D');
  static Color black = HexColor('#292929'); //1F1F1F
  static Color completelyBlack = Colors.black;

  ///SECONDARY COLORS
  static Color blue = HexColor('#1E96ED');
  static Color errorRed = Colors.redAccent;
  static Color yellow = HexColor('#f7c631');

  ///OTHER COLORS
  static Color transparent = Colors.transparent;
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
