import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

class AppInfoCarousel extends StatefulWidget {
  const AppInfoCarousel({Key? key}) : super(key: key);

  @override
  _AppInfoCarouselState createState() => _AppInfoCarouselState();
}

class _AppInfoCarouselState extends State<AppInfoCarousel> {
  //NOTIFIER FOR DOTED INDICATOR
  late ValueNotifier<int> pageNotifier;
  //CONTROLLER FOR PAGE VIEW
  late PageController controller;
  //TIMER FOR CAROUSEL
  late Timer timer;
  //PAGER CURRENT PAGE
  int currentPage = 0;

  @override
  void initState() {
    ///PAGE VIEW CONTROLLER INIT
    controller = PageController(
      initialPage: 0,
    );

    ///INDICATOR CONTROLLER INIT
    pageNotifier = new ValueNotifier<int>(0);

    ///CAROUSEL TIMER INIT
    timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      controller.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight() * 0.1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  pageNotifier.value = index;
                  currentPage = index;
                });
              },
              children: [
                buildInfoPageOne(),
                Platform.isAndroid
                    ? buildAndroidInfoPageTwo()
                    : buildIosInfoPageTwo(),
                buildInfoPageThree(),
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          CirclePageIndicator(
            dotColor: ColorMapper.getWhite().withOpacity(0.5),
            selectedDotColor: ColorMapper.getWhite(),
            currentPageNotifier: pageNotifier,
            size: AppIconSizes.icon_size_4,
            selectedSize: AppIconSizes.icon_size_6,
            itemCount: 3,
          ),
        ],
      ),
    );
  }

  Column buildInfoPageOne() {
    ///
    String word = AppLocale.of().welcomeToMehaley;
    String lastWordRemoved = word.substring(0, word.lastIndexOf(" "));
    String lastWord = word.substring(word.lastIndexOf(" "), word.length);

    ///

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: "Welcome to",
          titleTwo: "Mehaleye",
          isOdd: false,
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_24 * 2,
          ),
          child: Text(
            "Listen to Ethiopian orthodox tewahedo mezmurs, teachings and kidases. stream or download mezmurs to listen offline"
                .toUpperCase()
                .toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: ColorMapper.getLightGrey(),
            ),
          ),
        ),
      ],
    );
  }

  Column buildAndroidInfoPageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: "Pay",
          titleTwo: "With",
          isOdd: true,
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),

        ///DOMESTIC
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: "TELEBIRR"),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: "YENEPAY"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: "GOOGLE ACCOUNT"),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: "APPLE ID"),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_4,
        ),
      ],
    );
  }

  Column buildIosInfoPageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: "Use",
          titleTwo: "Your",
          isOdd: true,
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //buildPayWithItemsDivider(),
            buildPayWithItemsText(
                paymentMethodName: "APPLE ID TO PURCHASE MEZMURS"),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_4,
        ),
      ],
    );
  }

  Text buildPayWithItemsText({required String paymentMethodName}) {
    return Text(
      paymentMethodName.toUpperCase(),
      style: TextStyle(
        color: ColorMapper.getWhite(),
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        fontSize: AppFontSizes.font_size_8.sp,
      ),
    );
  }

  Container buildPayWithItemsDivider() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_8,
      ),
      child: Icon(
        Icons.circle,
        color: ColorMapper.getOrange(),
        size: AppIconSizes.icon_size_4,
      ),
    );
  }

  Text buildInfoHeaderText(
      {required String titleOne,
      required String titleTwo,
      required bool isOdd}) {
    return Text.rich(
      TextSpan(
        text: titleOne.toUpperCase(),
        style: TextStyle(
          color: isOdd ? ColorMapper.getOrange() : ColorMapper.getWhite(),
          fontWeight: FontWeight.bold,
          fontSize: AppFontSizes.font_size_10.sp,
        ),
        children: <InlineSpan>[
          TextSpan(text: ' '),
          TextSpan(
            text: titleTwo.toUpperCase(),
            style: TextStyle(
              color: isOdd ? ColorMapper.getWhite() : ColorMapper.getOrange(),
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Column buildInfoPageThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: "Subscribe TO",
          titleTwo: "Mehaleye",
          isOdd: false,
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_24 * 2,
          ),
          child: Text(
            "Subscribe to mehaleye and get unlimited access to all streams and downloads."
                .toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: ColorMapper.getLightGrey(),
            ),
          ),
        ),
      ],
    );
  }
}
