import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';

class WebirrPayment extends Equatable {
  final int paymentId;
  final String paymentReference;
  final DateTime confirmedTime;
  final PaymentMethod paymentMethod;
  final DateTime paymentDate;

  WebirrPayment({
    required this.paymentId,
    required this.paymentReference,
    required this.confirmedTime,
    required this.paymentMethod,
    required this.paymentDate,
  });

  @override
  List<Object?> get props => [
        paymentId,
        paymentReference,
        confirmedTime,
        paymentMethod,
        paymentDate,
      ];

  factory WebirrPayment.fromJson(Map<String, dynamic> json) {
    return WebirrPayment(
      paymentId: json["payment_id"],
      paymentReference: json["payment_reference"],
      confirmedTime: DateTime.parse(json["confirmed_time"]),
      paymentMethod: PaymentMethod.fromMap(json["payment_method"]),
      paymentDate: DateTime.parse(json["payment_date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "payment_id": this.paymentId,
      "payment_reference": this.paymentReference,
      "confirmed_time": this.confirmedTime.toIso8601String(),
      "payment_method": this.paymentMethod,
      "payment_date": this.paymentDate.toIso8601String(),
    };
  }
}
