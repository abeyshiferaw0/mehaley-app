import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

import 'artist.dart';

class Group extends Equatable {
  final int? groupId;
  final TextLan groupTitleText;
  final TextLan? groupSubTitleText;
  final RemoteImage? headerImageId;
  final bool? is_visible;
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
    required this.is_visible,
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
        is_visible,
      ];

  factory Group.fromMap(Map<String, dynamic> map) {
    //PARSE GROUP ITEMS BASED ON GROUP ITEM
    List<dynamic> parseGroupItems(GroupType mGroupType, List<dynamic> items) {
      if (mGroupType == GroupType.SONG) {
        return items.map((song) => Song.fromMap(song)).toList();
      } else if (mGroupType == GroupType.PLAYLIST) {
        return items.map((playlist) => Playlist.fromMap(playlist)).toList();
      } else if (mGroupType == GroupType.ARTIST) {
        return items.map((artist) => Artist.fromMap(artist)).toList();
      } else if (mGroupType == GroupType.ALBUM) {
        return items.map((album) => Album.fromMap(album)).toList();
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
          map['group_items']),
      is_visible: map['is_visible'] != null
          ? map['is_visible'] == 1
              ? true
              : false
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'group_id': this.groupId,
      'group_title_text_id': this.groupTitleText,
      'group_sub_title_text_id': this.groupSubTitleText,
      'header_image_id': this.headerImageId,
      'group_items': this.groupItems,
      'group_type': this.groupType,
      'group_ui_type': this.groupUiType,
      'group_date_created': this.groupDateCreated,
      'group_date_updated': this.groupDateUpdated,
    } as Map<String, dynamic>;
  }
}
