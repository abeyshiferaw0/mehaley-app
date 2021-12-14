import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/wallet_history_group.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_history_item.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:sizer/sizer.dart';

class WalletHistoryGroupItem extends StatelessWidget {
  const WalletHistoryGroupItem({Key? key, required this.walletHistoryGroup})
      : super(key: key);

  final WalletHistoryGroup walletHistoryGroup;

  @override
  Widget build(BuildContext context) {
    if (walletHistoryGroup.walletHistoryList.length > 0) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppMargin.margin_16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              walletHistoryGroup.dateTime.isToday
                  ? AppLocale.of().today.toUpperCase()
                  : walletHistoryGroup.dateTime.isYesterday
                      ? AppLocale.of().yesterday.toUpperCase()
                      : DateFormat('dd MMM')
                          .format(walletHistoryGroup.dateTime),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.txtGrey,
              ),
            ),
            SizedBox(height: AppMargin.margin_24),
            ListView.separated(
              itemCount: walletHistoryGroup.walletHistoryList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return WalletHistoryItem(
                  walletHistory:
                      walletHistoryGroup.walletHistoryList.elementAt(index),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: AppMargin.margin_16);
              },
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
