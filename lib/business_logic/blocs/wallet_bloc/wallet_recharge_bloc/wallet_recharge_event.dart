part of 'wallet_recharge_bloc.dart';

abstract class WalletRechargeEvent extends Equatable {
  const WalletRechargeEvent();
}

class RechargeWalletEvent extends WalletRechargeEvent {
  final double selectedAmount;
  final bool shouldCancelPreviousBill;

  RechargeWalletEvent(
      {required this.selectedAmount, required this.shouldCancelPreviousBill});

  @override
  List<Object?> get props => [
        selectedAmount,
        shouldCancelPreviousBill,
      ];
}
