import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/iap_subscription_restore_bloc/iap_subscription_restore_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_loading.dart';

class IapSubscriptionRestoringWidget extends StatelessWidget {
  const IapSubscriptionRestoringWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IapSubscriptionRestoreBloc, IapSubscriptionRestoreState>(
      builder: (context, state) {
        if (state is IapSubscriptionRestoringState) {
          return Container(
            color: AppColors.completelyBlack.withOpacity(0.5),
            child: Center(
              child: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
