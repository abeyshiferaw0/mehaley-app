part of 'iap_purchase_verification_bloc.dart';

abstract class IapPurchaseVerificationState extends Equatable {
  const IapPurchaseVerificationState();
}

class IapPurchaseVerificationInitial extends IapPurchaseVerificationState {
  @override
  List<Object> get props => [];
}

class IapPurchaseVerificationLoadingState extends IapPurchaseVerificationState {
  @override
  List<Object> get props => [];
}

class IapPurchaseVerificationLoadingErrorState
    extends IapPurchaseVerificationState {
  final String error;

  IapPurchaseVerificationLoadingErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class IapPurchaseVerificationLoadedState extends IapPurchaseVerificationState {
  final bool isValid;

  IapPurchaseVerificationLoadedState({required this.isValid});
  @override
  List<Object> get props => [isValid];
}
