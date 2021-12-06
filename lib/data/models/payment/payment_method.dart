import 'package:equatable/equatable.dart';

import '../remote_image.dart';
import '../text_lan.dart';

class PaymentMethod extends Equatable {
  final TextLan paymentMethodName;
  final RemoteImage imageUrl;
  final String helpUrl;

  PaymentMethod({
    required this.paymentMethodName,
    required this.imageUrl,
    required this.helpUrl,
  });

  @override
  List<Object?> get props => [
        paymentMethodName,
        imageUrl,
        helpUrl,
      ];

  factory PaymentMethod.fromMap(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodName: TextLan.fromMap(json["payment_method_name"]),
      imageUrl: RemoteImage.fromMap(json["image_url"]),
      helpUrl: json["help_url"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "payment_method_name": this.paymentMethodName,
      "image_url": this.imageUrl,
      "help_url": this.helpUrl,
    };
  }
}
