import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/enums/enums.dart';

part 'iap_product.g.dart';

@HiveType(typeId: 20)
class IapProduct extends Equatable {
  @HiveField(0)
  final String productId;
  @HiveField(1)
  final double productPrice;
  @HiveField(2)
  final IapProductTypes iapProductType;

  IapProduct({
    required this.productId,
    required this.productPrice,
    required this.iapProductType,
  });

  @override
  List<Object?> get props => [
        productId,
        productPrice,
        iapProductType,
      ];

  factory IapProduct.fromJson(Map<String, dynamic> json) {
    return IapProduct(
      productId: json["product_id"],
      productPrice: json["product_price"],
      iapProductType: EnumToString.fromString(
          IapProductTypes.values, json["product_type"])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": this.productId,
      "product_price": this.productPrice,
      "product_type": EnumToString.convertToString(this.iapProductType),
    };
  }
//

}
