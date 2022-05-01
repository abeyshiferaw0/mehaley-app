import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

class AppCommonToastWidget extends StatefulWidget {
  const AppCommonToastWidget(
      {Key? key,
      required this.bgColor,
      this.icon,
      required this.text,
      this.iconColor,
      required this.textColor})
      : super(key: key);

  final IconData? icon;
  final Color? iconColor;
  final String text;
  final Color textColor;
  final Color bgColor;

  @override
  State<AppCommonToastWidget> createState() => _AppCommonToastWidgetState();
}

class _AppCommonToastWidgetState extends State<AppCommonToastWidget> {
  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = L10nUtil.getCurrentLocale();

    return AppCard(
      radius: 12,
      child: Container(
        color: widget.bgColor,
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_12,
          horizontal: AppPadding.padding_16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon != null
                ? Row(
                    children: [
                      Icon(
                        widget.icon,
                        size: AppIconSizes.icon_size_24,
                        color: widget.iconColor != null
                            ? widget.iconColor
                            : AppColors.white,
                      ),
                      SizedBox(
                        width: AppMargin.margin_20,
                      ),
                    ],
                  )
                : SizedBox(),
            Text(
              widget.text,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (AppFontSizes.font_size_8 + 1).sp,
                fontWeight: FontWeight.w400,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
