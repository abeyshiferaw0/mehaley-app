import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/dialog/dialog_close_payment_auth_dialog.dart';

import 'app_bouncing_button.dart';

class AppTopHeaderWithIcon extends StatelessWidget {
  const AppTopHeaderWithIcon({
    Key? key,
    this.isForNewAppVersionDialog = false,
    this.disableCloseButton = false,
    this.enableCloseWarning,
  }) : super(key: key);

  final bool isForNewAppVersionDialog;
  final bool disableCloseButton;
  final bool? enableCloseWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_8,
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        border: !isForNewAppVersionDialog
            ? Border(
                bottom: BorderSide(
                  width: 1,
                  color: ColorMapper.getLightGrey(),
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppIconSizes.icon_size_24,
              ),
              child: Image.asset(
                AppAssets.icAppWordIcon,
                height: isForNewAppVersionDialog
                    ? AppIconSizes.icon_size_20
                    : AppIconSizes.icon_size_16,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (!disableCloseButton)
            AppBouncingButton(
              onTap: () {
                if (enableCloseWarning != null) {
                  if (enableCloseWarning!) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: DialogClosePaymentAuthDialog(
                            titleText: 'Cancel payment process',
                            descText:
                                'are you sure you want to cancel authenticating your phone number',
                            onClose: () {
                              Navigator.pop(context);
                            },
                            mainButtonText: 'Continue',
                            cancelButtonText: 'Cancel',
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.padding_4),
                child: Container(
                  child: Icon(
                    FlutterRemix.close_line,
                    color: ColorMapper.getBlack(),
                    size: AppIconSizes.icon_size_24,
                  ),
                ),
              ),
            )
          else
            SizedBox(),
        ],
      ),
    );
  }
}
