import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

class SaveUserData extends Equatable {
  final AppUser appUser;
  final String accessToken;

  const SaveUserData({
    required this.appUser,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        appUser,
        accessToken,
      ];
}
