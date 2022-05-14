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
        actionPhoneNumber,
        actionLaunchLink,
        maxAdLength,
      ];

  factory AppAd.fromMap(Map<String, dynamic> json) {
    return AppAd(
      id: json['ad_id'],
      link: Uri.parse(json['link']),
      appAddEmbedPlace: EnumToString.fromString(
        AppAddEmbedPlace.values,
        json['embed_place'],
      )!,
      appAdAction: json['action'] != null
          ? EnumToString.fromString(AppAdAction.values, json['action'])
          : null,
      preferredHeight: json['preferred_height'] != null
          ? json['preferred_height'] > AppValues.appAdPreferredMaxHeight
              ? AppValues.appAdPreferredMaxHeight
              : json['preferred_height']
          : null,
      actionPhoneNumber:
          json['phone_number'] != null ? json['phone_number'] : null,
      actionLaunchLink:
          json['launch_link'] != null ? Uri.parse(json['launch_link']) : null,
      maxAdLength: json['max_ad_length'] != null
          ? json['max_ad_length']! > AppValues.appAdMaxLength
              ? AppValues.appAdMaxLength
              : json['max_ad_length']
          : AppValues.appAdMaxLength,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad_id': this.id,
      'link': this.link,
      'embed_place': this.appAddEmbedPlace,
      'action': this.appAdAction,
      'phone_number': this.actionPhoneNumber,
      'launch_link': this.actionLaunchLink,
      'preferred_height': this.preferredHeight,
      'max_ad_length': this.maxAdLength,
    };
  }
}
