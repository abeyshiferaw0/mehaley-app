import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/constants.dart';

import 'enums/enums.dart';

class AppAd extends Equatable {
  final int id;
  final Uri link;
  final AppAddEmbedPlace appAddEmbedPlace;
  final AppAdAction? appAdAction;
  final String? actionPhoneNumber;
  final Uri? actionLaunchLink;
  final double preferredHeight;
  final int maxAdLength;

  AppAd(
      {required this.id,
      required this.link,
      required this.appAddEmbedPlace,
      this.appAdAction,
      required this.preferredHeight,
      this.actionPhoneNumber,
      this.actionLaunchLink,
      required this.maxAdLength});

  @override
  List<Object?> get props => [
        id,
        link,
        appAddEmbedPlace,
        appAdAction,
        preferredHeight,
        preferredHeight,
        actionPhoneNumber,
        maxAdLength,
      ];

  factory AppAd.fromMap(Map<String, dynamic> json) {
    return AppAd(
      id: int.parse(json["id"]),
      link: Uri.parse(json["link"]),
      appAddEmbedPlace: EnumToString.fromString(
        AppAddEmbedPlace.values,
        json["appAddEmbedPlace"],
      )!,
      appAdAction:
          EnumToString.fromString(AppAdAction.values, json["appAdAction"]),
      preferredHeight: json["preferredHeight"] != null
          ? json["preferredHeight"] > AppValues.appAdPreferredMaxHeight
              ? AppValues.appAdPreferredMaxHeight
              : json["preferredHeight"]
          : null,
      maxAdLength: json["maxAdLength"] != null
          ? json["maxAdLength"]! > AppValues.appAdMaxLength
              ? AppValues.appAdMaxLength
              : json["maxAdLength"]
          : AppValues.appAdMaxLength,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "link": this.link,
      "appAddEmbedPlace": this.appAddEmbedPlace,
      "appAdAction": this.appAdAction,
      "preferredHeight": this.preferredHeight,
    };
  }
}
