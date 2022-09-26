import 'package:equatable/equatable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapSubscriptionOfferings extends Equatable {
  final String title;
  final String description;
  final String priceDescription;
  final String? savingDescription;
  final String subTitle;
  final Offering offering;
  final IosAdditionalInfo? iosAdditionalInfo;

  ///GRADIENT COLORS
  final HexColor textColor;
  final HexColor color1;
  final HexColor color2;
  final HexColor color3;

  IapSubscriptionOfferings({
    required this.title,
    required this.description,
    required this.priceDescription,
    required this.savingDescription,
    required this.subTitle,
    required this.textColor,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.offering,
    this.iosAdditionalInfo,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        priceDescription,
        savingDescription,
        subTitle,
        textColor,
        color1,
        color2,
        color3,
        offering,
        iosAdditionalInfo,
      ];

  factory IapSubscriptionOfferings.fromJson(Map<String, dynamic> json, offering) {
    return IapSubscriptionOfferings(
      title: json["package_info"]["title"],
      description: json["package_info"]["description"],
      priceDescription: json["package_info"]["priceDescription"],
      savingDescription: json["package_info"]["savingDescription"],
      subTitle: json["package_info"]["subTitle"],
      textColor: HexColor(json["package_info"]["textColor"]),
      color1: HexColor(json["package_info"]["color1"]),
      color2: HexColor(json["package_info"]["color2"]),
      color3: HexColor(json["package_info"]["color3"]),
      offering: offering,
      iosAdditionalInfo: json["ios_additional_info"] != null
          ? IosAdditionalInfo(
              buttonTitle: json["ios_additional_info"]["button_title"],
              priceDescription: json["ios_additional_info"]
                  ["price_description"],
            )
          : null,
    );
  }
//

}

class IosAdditionalInfo {
  final String buttonTitle;
  final String priceDescription;

  IosAdditionalInfo(
      {required this.buttonTitle, required this.priceDescription});
}
