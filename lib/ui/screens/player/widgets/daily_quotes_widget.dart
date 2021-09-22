import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DailyQuotesWidget extends StatefulWidget {
  final Color dominantColor;

  const DailyQuotesWidget({required this.dominantColor});

  @override
  _DailyQuotesWidgetState createState() => _DailyQuotesWidgetState();
}

class _DailyQuotesWidgetState extends State<DailyQuotesWidget> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late final result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_14),
      margin: EdgeInsets.all(AppMargin.margin_16),
      decoration: BoxDecoration(
        color: widget.dominantColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DAILY QUOTES",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
          Container(
            child: Text(
              'Jesus said unto him, Thou shalt love the Lord thy God with all thy heart, and with all thy soul, and with all thy mind. This is the first and great commandment. And the second is like unto it, Thou shalt love thy neighbour as thyself. On these two commandments hang all the law and the prophets. Matthew 22:37-40',
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_24,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ShareBtnWidget(),
          )
        ],
      ),
    );
  }
}
