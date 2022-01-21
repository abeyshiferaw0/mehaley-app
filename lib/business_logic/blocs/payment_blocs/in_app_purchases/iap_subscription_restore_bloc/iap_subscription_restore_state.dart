part of 'iap_subscription_restore_bloc.dart';

abstract class IapSubscriptionRestoreState extends Equatable {
  const IapSubscriptionRestoreState();
}

class IapSubscriptionRestoreInitial extends IapSubscriptionRestoreState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionRestoringState extends IapSubscriptionRestoreState {
  @override
  List<Object> get props => [];
}

class IapSubscriptionRestoredState extends IapSubscriptionRestoreState {
  final bool isSubscribed;

  IapSubscriptionRestoredState({required this.isSubscribed});

  @override
  List<Object> get props => [isSubscribed];
}

class IapSubscriptionRestoringErrorState extends IapSubscriptionRestoreState {
  final String error;

  IapSubscriptionRestoringErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
