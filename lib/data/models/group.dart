import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/text_lan.dart';

import 'artist.dart';

class Group extends Equatable {
  final int? groupId;
  final TextLan groupTitleText;
  final TextLan? groupSubTitleText;
  final RemoteImage? headerImageId;
  final bool isVisible;
  final List<dynamic> groupItems;
  final GroupType groupType;
  final GroupUiType groupUiType;
  final DateTime? groupDateCreated;
  final DateTime? groupDateUpdated;

  Group({
    required this.groupId,
    required this.groupTitleText,
    required this.groupSubTitleText,
    required this.headerImageId,
    required this.groupItems,
    required this.groupType,
    required this.groupUiType,
    required this.groupDateCreated,
    required this.groupDateUpdated,
    required this.isVisible,
  });

  @override
  List<Object?> get props => [
        groupId,
        groupTitleText,
        groupSubTitleText,
        headerImageId,
        groupItems,
        groupType,
        groupUiType,
        groupDateCreated,
        groupDateUpdated,
        isVisible,
      ];

  factory Group.fromMap(Map<String, dynamic> map, bool isAdminGroup) {
    //PARSE GROUP ITEMS BASED ON GROUP ITEM
    List<dynamic> parseGroupItems(GroupType mGroupType, List<dynamic> items) {
      if (mGroupType == GroupType.SONG) {
        return items
            .map((song) => Song.fromMap(isAdminGroup ? song['item'] : song))
            .toList();
      } else if (mGroupType == GroupType.PLAYLIST) {
        return items
            .map((playlist) =>
                Playlist.fromMap(isAdminGroup ? playlist['item'] : playlist))
            .toList();
      } else if (mGroupType == GroupType.ARTIST) {
        return items
            .map((artist) =>
                Artist.fromMap(isAdminGroup ? artist['item'] : artist))
            .toList();
      } else if (mGroupType == GroupType.ALBUM) {
        return items
            .map((album) => Album.fromMap(isAdminGroup ? album['item'] : album))
            .toList();
      } else {
        throw Exception("parsing group items error");
      }
    }

    return new Group(
      groupId: map['group_id'] != null ? map['group_id'] as int : null,
      groupTitleText: TextLan.fromMap(map['group_title_text_id']),
      groupSubTitleText: map['group_sub_title_text_id'] != null
          ? TextLan.fromMap(map['group_sub_title_text_id'])
          : null,
      headerImageId: map['header_image_id'] != null
          ? RemoteImage.fromMap(map['header_image_id'])
          : null,
      groupType: EnumToString.fromString(GroupType.values, map['group_type'])
          as GroupType,
      groupUiType:
          EnumToString.fromString(GroupUiType.values, map['group_ui_type'])
              as GroupUiType,
      groupDateCreated: map['group_date_created'] != null
          ? DateTime.parse(map['group_date_created'])
          : null,
      groupDateUpdated: map['group_date_updated'] != null
          ? DateTime.parse(map['group_date_updated'])
          : null,
      groupItems: parseGroupItems(
          EnumToString.fromString(GroupType.values, map['group_type'])
              as GroupType,
          map['items']),
      isVisible: map['is_visible'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'group_id': this.groupId,
      'group_title_text_id': this.groupTitleText,
      'group_sub_title_text_id': this.groupSubTitleText,
      'header_image_id': this.headerImageId,
      'items': this.groupItems,
      'group_type': this.groupType,
      'group_ui_type': this.groupUiType,
      'group_date_created': this.groupDateCreated,
      'group_date_updated': this.groupDateUpdated,
    } as Map<String, dynamic>;
  }
}
