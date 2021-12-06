import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';

class WalletHistoryGroup extends Equatable {
  final List<WalletHistory> walletHistoryList;
  final DateTime dateTime;

  WalletHistoryGroup({required this.walletHistoryList, required this.dateTime});

  @override
  List<Object?> get props => [
        walletHistoryList,
        dateTime,
      ];
}
