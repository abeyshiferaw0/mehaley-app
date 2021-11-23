import 'dart:async';

import 'package:flutter/material.dart';
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
                buildInfoPageTwo(),
                buildInfoPageThree(),
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          CirclePageIndicator(
            dotColor: AppColors.white.withOpacity(0.5),
            selectedDotColor: AppColors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: 'WELCOME TO',
          titleTwo: 'APP NAME',
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
            "Some Description About App and May be some slogan".toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      ],
    );
  }

  Column buildInfoPageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///TITLE
        buildInfoHeaderText(
          titleOne: 'Pay',
          titleTwo: 'With',
          isOdd: true,
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),

        ///DOMESTIC
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPayWithItemsText(paymentMethodName: 'Mbirr'),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: 'Cbe birr'),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: 'Amole'),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: 'hello cash'),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_4,
        ),

        ///INTERNATIONAL
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPayWithItemsText(paymentMethodName: 'MASTERCARD'),
            buildPayWithItemsDivider(),
            buildPayWithItemsText(paymentMethodName: 'VISA'),
          ],
        ),
      ],
    );
  }

  Text buildPayWithItemsText({required String paymentMethodName}) {
    return Text(
      paymentMethodName.toUpperCase(),
      style: TextStyle(
        color: AppColors.white,
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
        color: AppColors.orange,
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
          color: isOdd ? AppColors.orange : AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: AppFontSizes.font_size_10.sp,
        ),
        children: <InlineSpan>[
          TextSpan(text: ' '),
          TextSpan(
            text: titleTwo.toUpperCase(),
            style: TextStyle(
              color: isOdd ? AppColors.white : AppColors.orange,
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
          titleOne: 'Subscribe TO',
          titleTwo: 'APP NAME',
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
            "subscribe and get unlimited access to all mezmur streams"
                .toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      ],
    );
  }
}
