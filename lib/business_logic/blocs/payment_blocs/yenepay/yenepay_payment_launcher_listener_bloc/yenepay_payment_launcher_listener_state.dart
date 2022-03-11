part of 'yenepay_payment_launcher_listener_bloc.dart';

abstract class YenepayPaymentLauncherListenerState extends Equatable {
  const YenepayPaymentLauncherListenerState();
}

class YenepayPaymentLauncherListenerInitial
    extends YenepayPaymentLauncherListenerState {
  @override
  List<Object> get props => [];
}

class YenepayPaymentLaunchedState extends YenepayPaymentLauncherListenerState {
  final String launchUrl;

  YenepayPaymentLaunchedState({required this.launchUrl});

  @override
  List<Object?> get props => [launchUrl];
}

class YenepayPaymentLaunchErrorState
    extends YenepayPaymentLauncherListenerState {
  final String error;

  YenepayPaymentLaunchErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class YenepayPaymentParseErrorState
    extends YenepayPaymentLauncherListenerState {
  final String error;

  YenepayPaymentParseErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class YenepayPaymentStatusState extends YenepayPaymentLauncherListenerState {
  final YenepayPaymentStatus yenepayPaymentStatus;

  YenepayPaymentStatusState({required this.yenepayPaymentStatus});

  @override
  List<Object?> get props => [yenepayPaymentStatus];
}

class YenepayPaymentListenerStartedState
    extends YenepayPaymentLauncherListenerState {
  @override
  List<Object?> get props => [];
}
