import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/home_shortcut/shortcut_data.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/screens/home/widgets/item_home_shortcut.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class HomeShortcuts extends StatefulWidget {
  final ShortcutData shortcutData;

  const HomeShortcuts({Key? key, required this.shortcutData}) : super(key: key);

  @override
  State<HomeShortcuts> createState() => _HomeShortcutsState();
}

class _HomeShortcutsState extends State<HomeShortcuts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            greetingMessage(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.font_size_16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_12,
        ),
        Visibility(
          visible: getNumberOfItems() > 2 ? true : false,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppMargin.margin_16,
              top: AppMargin.margin_16,
              right: AppMargin.margin_16,
            ),
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: (3.3 / 1.0),
              crossAxisSpacing: AppMargin.margin_8,
              mainAxisSpacing: AppMargin.margin_8,
              crossAxisCount: 2,
              children: getShortCuts(context),
            ),
          ),
        )
      ],
    );
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  List<Widget> getShortCuts(context) {
    ///NUMBER OF GRID ITEMS MUST NOT BE OVER 6 AND MUST NOT BE ODD NUMBER
    int shortcutsSize = 6;
    List<Widget> shortCuts = [];

    ///ADD PURCHASED SHORT CUT
    if (widget.shortcutData.purchasedCount > 0) {
      shortCuts.add(
        ItemHomeShortcut(
          text: "Purchased Mezmurs",
          image: null,
          appItemsType: null,
          textMaxLines: 2,
          shortcutType: null,
          icon: PhosphorIcons.shopping_cart_simple_fill,
          gradient: AppGradients().getOfflineLibraryGradient(),
          onTap: () {
            BlocProvider.of<BottomBarCubit>(context).changeScreen(
              BottomBarPages.LIBRARY,
            );
            //////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////
            Navigator.pushNamed(
              context,
              AppRouterPaths.libraryRoute,
              arguments: ScreenArguments(
                args: {
                  AppValues.isLibraryForOffline: false,
                },
              ),
            );
          },
        ),
      );

      ///CHANGE DOMINANT COLOR
      BlocProvider.of<PagesDominantColorBloc>(context).add(
        HomePageDominantColorChanged(
          dominantColor:
              HexColor("#${AppColors.blue2.value.toRadixString(16)}"),
        ),
      );
      shortcutsSize = shortcutsSize - 1;
    }

    ///ADD OFFLINE SHORT CUT
    if (widget.shortcutData.downloadCount > 0) {
      shortCuts.add(
        ItemHomeShortcut(
          text: "Listen Offline",
          image: null,
          appItemsType: null,
          textMaxLines: 2,
          shortcutType: null,
          icon: PhosphorIcons.caret_circle_down_fill,
          gradient: AppGradients().getPurchasedLibraryGradient(),
          onTap: () {
            BlocProvider.of<BottomBarCubit>(context).changeScreen(
              BottomBarPages.LIBRARY,
            );
            //////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////
            Navigator.pushNamed(
              context,
              AppRouterPaths.libraryRoute,
              arguments: ScreenArguments(
                args: {AppValues.isLibraryForOffline: true},
              ),
            );
          },
        ),
      );

      ///CHANGE DOMINANT COLOR
      BlocProvider.of<PagesDominantColorBloc>(context).add(
        HomePageDominantColorChanged(
          dominantColor:
              HexColor("#${AppColors.orange1.value.toRadixString(16)}"),
        ),
      );
      shortcutsSize = shortcutsSize - 1;
    }

    ///ADD OTHER DYNAMIC SHORTCUTS
    for (var i = 0; i < widget.shortcutData.shortcuts.length; i++) {
      if (shortcutsSize > 0) {
        shortCuts.add(
          ItemHomeShortcut(
            text: PagesUtilFunctions.getShortCutText(
                widget.shortcutData.shortcuts[i], context),
            image: PagesUtilFunctions.getImage(
              widget.shortcutData.shortcuts[i],
            ),
            appItemsType: PagesUtilFunctions.getAppItemsType(
              widget.shortcutData.shortcuts[i],
            ),
            textMaxLines: 1,
            shortcutType: PagesUtilFunctions.getShortCutType(
              widget.shortcutData.shortcuts[i],
            ),
            icon: PhosphorIcons.caret_circle_down_fill,
            gradient: AppGradients().getPurchasedLibraryGradient(),
            onTap: () {
              PagesUtilFunctions.getShortCutClickAction(
                widget.shortcutData.shortcuts[i],
                context,
              );
            },
          ),
        );
        if (i == 0 &&
            widget.shortcutData.purchasedCount < 1 &&
            widget.shortcutData.downloadCount < 1) {
          BlocProvider.of<PagesDominantColorBloc>(context).add(
            HomePageDominantColorChanged(
              dominantColor: HexColor(
                PagesUtilFunctions.getImage(
                  widget.shortcutData.shortcuts[i],
                ).primaryColorHex,
              ),
            ),
          );
        }
        shortcutsSize = shortcutsSize - 1;
      }
    }

    ///CHECK IF WIDGETS SIZE IS ODD AND REMOVE LAST ONE
    if (shortCuts.length > 0) {
      if (shortCuts.length % 2 != 0) {
        shortCuts.removeLast();
      }
    }

    return shortCuts;
  }

  int getNumberOfItems() {
    int total = 0;
    if (widget.shortcutData.purchasedCount > 0) {
      total++;
    }
    if (widget.shortcutData.downloadCount > 0) {
      total++;
    }
    total = total + widget.shortcutData.shortcuts.length;
    return total;
  }
}
