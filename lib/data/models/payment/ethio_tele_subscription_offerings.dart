import 'package:equatable/equatable.dart';
import 'package:hexcolor/hexcolor.dart';

class EthioTeleSubscriptionOfferings extends Equatable {
  final String titleEn;
  final String titleAm;
  final String descriptionEn;
  final String descriptionAm;
  final String priceDescriptionEn;
  final String? savingDescriptionEn;
  final String subTitleEn;
  final String priceDescriptionAm;
  final String? savingDescriptionAm;
  final String subTitleAm;

  ///GRADIENT COLORS
  final HexColor textColor;
  final HexColor color1;
  final HexColor color2;
  final HexColor color3;

  ///FOR ONLY ETHIO TEL SUBSCRIPTION
  final String shortCode;
  final String shortCodeSubscribeTxt;

  EthioTeleSubscriptionOfferings({
    required this.titleEn,
    required this.titleAm,
    required this.descriptionEn,
    required this.descriptionAm,
    required this.priceDescriptionEn,
    required this.savingDescriptionEn,
    required this.subTitleEn,
    required this.priceDescriptionAm,
    required this.savingDescriptionAm,
    required this.subTitleAm,
    required this.shortCode,
    required this.shortCodeSubscribeTxt,
    required this.textColor,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  List<Object?> get props => [
        titleEn,
        titleAm,
        descriptionEn,
        descriptionAm,
        priceDescriptionEn,
        savingDescriptionEn,
        subTitleEn,
        priceDescriptionAm,
        savingDescriptionAm,
        subTitleAm,
        shortCode,
        shortCodeSubscribeTxt,
        textColor,
        color1,
        color2,
        color3,
      ];

  factory EthioTeleSubscriptionOfferings.fromJson(Map<String, dynamic> json) {
    return EthioTeleSubscriptionOfferings(
      titleAm: json["title_am"],
      titleEn: json["title_en"],
      descriptionEn: json["description_en"],
      descriptionAm: json["description_am"],
      priceDescriptionEn: json["priceDescription_en"],
      priceDescriptionAm: json["priceDescription_am"],
      shortCode: json["shortCode"],
      shortCodeSubscribeTxt: json["shortCodeSubscribeTxt"],
      savingDescriptionEn: json["savingDescription_en"],
      savingDescriptionAm: json["savingDescription_am"],
      subTitleEn: json["subTitle_en"],
      subTitleAm: json["subTitle_am"],
      textColor: HexColor(json["textColor"]),
      color1: HexColor(json["color1"]),
      color2: HexColor(json["color2"]),
      color3: HexColor(json["color3"]),
    );
  }
//

}
