import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'one_signal_event.dart';
part 'one_signal_state.dart';

class OneSignalBloc extends Bloc<OneSignalEvent, OneSignalState> {
  OneSignalBloc() : super(OneSignalInitial()) {
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) async {
        if (result.notification.additionalData != null) {
          if (result.notification.additionalData!.isNotEmpty) {
            if (result.notification.additionalData!.containsKey('item_id') &&
                result.notification.additionalData!.containsKey('item_type')) {
              try {
                ///PARSE ITEM ID
                ///CHECK IF ITEM ID IS INT OR STRING AND USE APPROPRIATELY
                late int itemId;
                if (result.notification.additionalData!['item_id'] is String) {
                  itemId =
                      int.parse(result.notification.additionalData!['item_id']);
                }
                if (result.notification.additionalData!['item_id'] is int) {
                  itemId =
                      result.notification.additionalData!['item_id'] as int;
                }

                ///PARSE ITEM TYPE
                AppItemsType? itemType = EnumToString.fromString(
                  AppItemsType.values,
                  result.notification.additionalData!['item_type'] as String,
                );
                if (itemType != null) {
                  this.add(
                    NotificationClickedEvent(
                      itemId: itemId,
                      itemType: itemType,
                    ),
                  );
                }
              } catch (e) {
                this.add(NotificationClickedErrorEvent(error: e.toString()));
              }
            }
          }
        }
      },
    );
  }

  @override
  Stream<OneSignalState> mapEventToState(OneSignalEvent event) async* {
    if (event is SetNotificationTagEvent) {
      yield OneSignalTagAdding();
      OneSignal.shared
          .sendTag(
            EnumToString.convertToString(event.appUserNotificationTypes),
            getChangedNotificationValue(
              event.appUserNotificationTypes,
              event.notificationTags,
            ),
          )
          .then((tagsSent) => {this.add(SetNotificationTagSuccessEvent())})
          .catchError((e) {
        this.add(SetNotificationTagErrorEvent(error: e.toString()));
      });
    } else if (event is SetNotificationTagSuccessEvent) {
      yield OneSignalTagAdded();
    } else if (event is SetNotificationTagErrorEvent) {
      yield OneSignalTagAddingError(error: event.error);
    } else if (event is NotificationClickedEvent) {
      yield NotificationClickedState(
        itemId: event.itemId,
        itemType: event.itemType,
      );
    } else if (event is NotificationClickedErrorEvent) {
      yield NotificationClickedErrorState(error: event.error);
    }
  }

  String getChangedNotificationValue(
    AppUserNotificationTypes appUserNotificationTypes,
    Map<String, dynamic> notificationTags,
  ) {
    ///IF NOTIFICATION FOR THIS ENUM IS ENABLED PREVIOUSLY TURN OFF AND VISE VERSA
    if (notificationTags.containsKey(
      EnumToString.convertToString(appUserNotificationTypes),
    )) {
      String val = notificationTags[
          EnumToString.convertToString(appUserNotificationTypes)];
      if (int.parse(val) == 1) {
        return '0';
      }
      return '1';
    }
    return '1';
  }
}
