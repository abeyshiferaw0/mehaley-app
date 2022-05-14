import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/yenepay_payment_status.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

part 'yenepay_payment_launcher_listener_event.dart';
part 'yenepay_payment_launcher_listener_state.dart';

class YenepayPaymentLauncherListenerBloc extends Bloc<
    YenepayPaymentLauncherListenerEvent, YenepayPaymentLauncherListenerState> {
  YenepayPaymentLauncherListenerBloc()
      : super(YenepayPaymentLauncherListenerInitial()) {
    ///LISTEN TO YENEPAY REDIRECT DEEPLINK
    streamSubscription = linkStream.listen((String? link) async {
      if (link != null) {
        Uri deeplinkUri = Uri.parse(link.unescape());
        if (deeplinkUri.host == 'yenepay') {
          ///CLOSE URL LAUNCHED WEB PAGE
          await closeWebView();
          try {
            ///PARSE DEEPLINK URL TO YenepayPaymentStatus
            YenepayPaymentStatus yenepayPaymentStatus =
                YenepayPaymentStatus.fromJson(
              deeplinkUri.queryParameters,
            );
            print("YenepayPaymentStatusState=> ${yenepayPaymentStatus.itemId}");
            this.add(
              YenepayPaymentStatusEvent(
                yenepayPaymentStatus: yenepayPaymentStatus,
              ),
            );
          } catch (e) {
            ///HANDLE ERROR
            this.add(
              YenepayPaymentParseErrorEvent(
                error: 'ERROR PARSING DEEPLINK ${e.toString()}',
              ),
            );
          }
        }
      } else {
        // ///HANDLE ERROR
        // this.add(YenepayPaymentLaunchErrorEvent(error: 'DEEPLINK IS NULL'));
      }
    }, onError: (err) {
      // ///HANDLE ERROR
      // this.add(YenepayPaymentLaunchErrorEvent(error: err.toString()));
    });
  }

  late StreamSubscription streamSubscription;

  @override
  Stream<YenepayPaymentLauncherListenerState> mapEventToState(
      YenepayPaymentLauncherListenerEvent event) async* {
    if (event is LaunchYenepayPaymentPageEvent) {
      if (await canLaunchUrl(event.launchUrl)) {
        await launch(event.launchUrl);
        yield YenepayPaymentLaunchedState(launchUrl: event.launchUrl);

        ///ADD ANOTHER DUMMY STATE SO THAT STATE CAN BE YIELDED AGAIN
        yield YenepayPaymentLauncherListenerInitial();
      } else {
        yield YenepayPaymentLaunchErrorState(
          error: 'ERROR_LAUNCHING_YENEPAY_PAYMENT_PAGE',
        );

        ///ADD ANOTHER DUMMY STATE SO THAT STATE CAN BE YIELDED AGAIN
        yield YenepayPaymentLauncherListenerInitial();
      }
    } else if (event is YenepayPaymentStatusEvent) {
      print("YenepayPaymentStatusState=> ${event.yenepayPaymentStatus.itemId}");
      yield YenepayPaymentStatusState(
        yenepayPaymentStatus: event.yenepayPaymentStatus,
      );

      ///ADD ANOTHER DUMMY STATE SO THAT STATE CAN BE YIELDED AGAIN
      yield YenepayPaymentLauncherListenerInitial();
    } else if (event is YenepayPaymentParseErrorEvent) {
      yield YenepayPaymentParseErrorState(error: event.error);

      ///ADD ANOTHER DUMMY STATE SO THAT STATE CAN BE YIELDED AGAIN
      yield YenepayPaymentLauncherListenerInitial();
    } else if (event is StartYenepayPaymentListenerEvent) {
      yield YenepayPaymentListenerStartedState();

      ///ADD ANOTHER DUMMY STATE SO THAT STATE CAN BE YIELDED AGAIN
      yield YenepayPaymentLauncherListenerInitial();
    }
  }

  Future<bool> canLaunchUrl(String urlString) async {
    return await canLaunch(urlString);
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
