import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method_image.dart';

class PaymentMethod extends Equatable {
  final AppPaymentMethods appPaymentMethods;
  final bool isSelected;
  final String title;
  final String description;
  final bool isAvailable;
  final PaymentMethodImage paymentMethodImage;
  final List<PaymentMethodImage> paymentOptionImages;

  PaymentMethod({
    required this.appPaymentMethods,
    required this.isSelected,
    required this.title,
    required this.isAvailable,
    required this.description,
    required this.paymentMethodImage,
    required this.paymentOptionImages,
  });

  @override
  List<Object?> get props => [
        appPaymentMethods,
        isSelected,
        title,
        isAvailable,
        description,
        paymentMethodImage,
        paymentOptionImages,
      ];

  PaymentMethod copyWith({
    AppPaymentMethods? appPaymentMethods,
    bool? isSelected,
    String? title,
    bool? isAvailable,
    String? description,
    PaymentMethodImage? paymentMethodImage,
    List<PaymentMethodImage>? paymentOptionImages,
  }) {
    return PaymentMethod(
      appPaymentMethods: appPaymentMethods ?? this.appPaymentMethods,
      isSelected: isSelected ?? this.isSelected,
      title: title ?? this.title,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description ?? this.description,
      paymentMethodImage: paymentMethodImage ?? this.paymentMethodImage,
      paymentOptionImages: paymentOptionImages ?? this.paymentOptionImages,
    );
  }
}
