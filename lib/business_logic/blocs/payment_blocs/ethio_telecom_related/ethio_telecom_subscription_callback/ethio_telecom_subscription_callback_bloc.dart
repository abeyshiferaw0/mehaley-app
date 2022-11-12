import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_subscription_util.dart';

part 'ethio_telecom_subscription_callback_event.dart';

part 'ethio_telecom_subscription_callback_state.dart';

class EthioTelecomSubscriptionCallbackBloc extends Bloc<
    EthioTelecomSubscriptionCallbackEvent,
    EthioTelecomSubscriptionCallbackState> {
  EthioTelecomSubscriptionCallbackBloc()
      : super(EthioTelecomSubscriptionCallbackInitial());

  @override
  Stream<EthioTelecomSubscriptionCallbackState> mapEventToState(
      EthioTelecomSubscriptionCallbackEvent event) async* {
    if (event is EthioTeleSubCallbackEvent) {
      try {
        ///CHECK IF USER SUBSCRIPTION STATUS EXISTS
        if (event.headers.map.containsKey(
          AppValues.userLocalSubscriptionStatusHeader.toLowerCase(),
        )) {
          ///
          var userLocalSubscriptionStatus = event.headers
              .map[AppValues.userLocalSubscriptionStatusHeader.toLowerCase()];

          if (userLocalSubscriptionStatus != null) {
            if (userLocalSubscriptionStatus.length > 0) {
              ///
              String subStatus = userLocalSubscriptionStatus.first;

              ///CHECK IF STATUS IS ONE OF FIVE DEFINED STATUES
              if (isStatesOneOfFive(subStatus)) {
                ///GET PREVIOUS STATE BEFORE UPDATING NEW ONE
                LocalUserSubscriptionStatus? preStatus =
                    EthioTelecomSubscriptionUtil.getUserSavedLocalSubStatus();

                ///GET CURRENT FETCHED STATUS
                LocalUserSubscriptionStatus nowStatus = EnumToString.fromString(
                  LocalUserSubscriptionStatus.values,
                  subStatus.toUpperCase(),
                )!;

                print("TESTTT => ${nowStatus} ${preStatus}");

                ///STORE USER LOCAL SUBSCRIPTION STATUS
                await EthioTelecomSubscriptionUtil.storeUserLocalSubStatus(
                  nowStatus,
                );

                ///
                // if (nowStatus == LocalUserSubscriptionStatus.ACTIVE) {
                //   ///SET USER IS SUBSCRIBED STATUS
                //   await iapSubscriptionRepository.setUserIsSubscribes(true);
                // } else {
                //   ///SET USER IS SUBSCRIBED STATUS
                //   await iapSubscriptionRepository.setUserIsSubscribes(false);
                // }

                if (EthioTelecomSubscriptionUtil.doesUserSubStatusExists()) {
                  ///IF PRE STATUS WAS ACTIVE
                  if (preStatus != LocalUserSubscriptionStatus.DEACTIVATED) {
                    ///IF NOW STATUS IS NOT ACTIVE SHOW SUBSCRIPTION DEACTIVATION DIALOG
                    if (nowStatus == LocalUserSubscriptionStatus.DEACTIVATED) {
                      ///SHOW DIALOG
                      yield ShowLocalSubscriptionDeActivateDialog();
                    }
                  } else {
                    ///IF NOW STATUS IS ACTIVE SHOW SUBSCRIPTION ACTIVE DIALOG
                    if (nowStatus != LocalUserSubscriptionStatus.DEACTIVATED) {
                      ///SHOW DIALOG
                      yield ShowLocalSubscriptionActiveDialog();
                    }
                  }
                } else {
                  ///IF STATUS IS ACTIVE SHOW SUBSCRIPTION ACTIVE DIALOG
                  if (nowStatus != LocalUserSubscriptionStatus.DEACTIVATED) {
                    ///SHOW DIALOG

                    yield ShowLocalSubscriptionActiveDialog();
                  }
                }
              }
            }
          }
        }

        ///YIELD INITIAL STATE JUST IN CASE
        yield EthioTelecomSubscriptionCallbackInitial();
      } catch (e) {
        ///SOME ERROR WHILE PARSING
        yield EthioTelecomSubscriptionCallbackErrorState();
      }
    }
  }

  bool isStatesOneOfFive(String subStatus) {
    bool isStatesOneOfFive = false;

    LocalUserSubscriptionStatus.values.forEach((element) {
      if (element ==
          EnumToString.fromString(
              LocalUserSubscriptionStatus.values, subStatus.toUpperCase())) {
        isStatesOneOfFive = true;
      }
    });

    return isStatesOneOfFive;
  }
}
