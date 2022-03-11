part of 'yenepay_payment_launcher_listener_bloc.dart';

abstract class YenepayPaymentLauncherListenerEvent extends Equatable {
  const YenepayPaymentLauncherListenerEvent();
}

class StartYenepayPaymentListenerEvent
    extends YenepayPaymentLauncherListenerEvent {
  @override
  List<Object?> get props => [];
}

class LaunchYenepayPaymentPageEvent
    extends YenepayPaymentLauncherListenerEvent {
  final String launchUrl;

  LaunchYenepayPaymentPageEvent({required this.launchUrl});

  @override
  List<Object?> get props => [launchUrl];
}

class YenepayPaymentParseErrorEvent
    extends YenepayPaymentLauncherListenerEvent {
  final String error;

  YenepayPaymentParseErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class YenepayPaymentStatusEvent extends YenepayPaymentLauncherListenerEvent {
  final YenepayPaymentStatus yenepayPaymentStatus;

  YenepayPaymentStatusEvent({required this.yenepayPaymentStatus});

  @override
  List<Object?> get props => [yenepayPaymentStatus];
}
