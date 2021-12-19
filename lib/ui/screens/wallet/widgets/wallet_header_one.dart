import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/open_profile_page_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class WalletHeaderOne extends StatelessWidget {
  const WalletHeaderOne(
      {Key? key, required this.height, required this.walletPageData})
      : super(key: key);

  final double height;
  final WalletPageData walletPageData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<AppUserWidgetsCubit, AppUser>(
                          builder: (context, state) {
                            return Text(
                              '${PagesUtilFunctions.getUserGreeting()} ${AuthUtil.getUserName(state)}',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: AppPadding.padding_4,
                        ),
                        Text(
                          '${DateFormat.yMMMMd().format(walletPageData.today).toString()}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_8.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppMargin.margin_16,
                  ),
                  AppBouncingButton(
                    onTap: () {
                      Navigator.pop(context);
                      BlocProvider.of<OpenProfilePageCubit>(context).openPage();
                    },
                    child: AppCard(
                      radius: AppValues.profilePagePicSize * 0.5,
                      withShadow: true,
                      child: UserProfilePic(
                        fontSize: AppFontSizes.font_size_16.sp,
                        size: AppValues.profilePagePicSize * 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 0.5,
            color: AppColors.lightGrey,
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }
}
