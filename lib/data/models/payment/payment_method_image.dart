import 'package:equatable/equatable.dart';

class PaymentMethodImage extends Equatable {
  final String imagePath;
  final double height;

  PaymentMethodImage({
    required this.imagePath,
    required this.height,
  });

  @override
  List<Object?> get props => [
        imagePath,
        height,
      ];
}
