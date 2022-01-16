import 'package:equatable/equatable.dart';

class IapValidationResult extends Equatable {
  final bool isValid;
  final bool isAlreadyPurchased;

  const IapValidationResult({
    required this.isValid,
    required this.isAlreadyPurchased,
  });

  @override
  List<Object?> get props => [
        isValid,
        isAlreadyPurchased,
      ];
}
