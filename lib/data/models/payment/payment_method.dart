import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final int paymentMethodId;
  final String paymentMethodName;
  final String imageUrl;
  final String helpUrl;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.imageUrl,
    required this.helpUrl,
  });

  @override
  List<Object?> get props => [
        paymentMethodId,
        paymentMethodName,
        imageUrl,
        helpUrl,
      ];

  factory PaymentMethod.fromMap(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json["payment_method_id"],
      paymentMethodName: json["payment_method_name"],
      imageUrl: json["image_url"],
      helpUrl: json["help_url"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "payment_method_id": this.paymentMethodId,
      "payment_method_name": this.paymentMethodName,
      "image_url": this.imageUrl,
      "help_url": this.helpUrl,
    };
  }
}
