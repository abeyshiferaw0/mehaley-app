part of 'wallet_recharge_initial_bloc.dart';

abstract class WalletRechargeInitialEvent extends Equatable {
  const WalletRechargeInitialEvent();
}

class CheckShouldWalletRechargeEvent extends WalletRechargeInitialEvent {
  @override
  List<Object?> get props => [];
}
