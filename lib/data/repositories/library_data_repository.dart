import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/library_data_provider.dart';

class LibraryDataRepository {
  ///INIT PROVIDER FOR API CALL
  final LibraryDataProvider libraryDataProvider;

  const LibraryDataRepository({required this.libraryDataProvider});

  ///FOR SONG
  Future<void> likeUnlikeSong(
      int id, AppLikeFollowEvents appLikeFollowEvents) async {
    ///LIKE OR UNLIKE SONG
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      await libraryDataProvider.likeSong(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      await libraryDataProvider.unlikeSong(id);
    } else {
      throw "SONG LIKE UNLIKE OPERATION NOT VALID";
    }
  }

  void addRecentlyLikedUnlikedSong(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyLikedSongBox.delete(id);
      AppHiveBoxes.instance.recentlyLikedSongBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyUnLikedSongBox.delete(id);
      AppHiveBoxes.instance.recentlyUnLikedSongBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeLikedUnlikedSong(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyUnLikedSongBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyLikedSongBox.delete(id);
    }
  }

  void removeRecentlyLikedUnlikedSong(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyLikedSongBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyUnLikedSongBox.delete(id);
    }
  }

  ///FOR ALBUM
  Future<void> likeUnlikeAlbum(
      int id, AppLikeFollowEvents appLikeFollowEvents) async {
    ///LIKE OR UNLIKE ALBUM
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      await libraryDataProvider.likeAlbum(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      await libraryDataProvider.unlikeAlbum(id);
    } else {
      throw "ALBUM LIKE UNLIKE OPERATION NOT VALID";
    }
  }

  void addRecentlyLikedUnlikedAlbum(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyLikedAlbumBox.delete(id);
      AppHiveBoxes.instance.recentlyLikedAlbumBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyUnLikedAlbumBox.delete(id);
      AppHiveBoxes.instance.recentlyUnLikedAlbumBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeLikedUnlikedAlbum(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyUnLikedAlbumBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyLikedAlbumBox.delete(id);
    }
  }

  void removeRecentlyLikedUnlikedAlbum(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.LIKE) {
      AppHiveBoxes.instance.recentlyLikedAlbumBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNLIKE) {
      AppHiveBoxes.instance.recentlyUnLikedAlbumBox.delete(id);
    }
  }

  ///FOR PLAYLIST
  Future<void> followUnFollowPlaylist(
      int id, AppLikeFollowEvents appLikeFollowEvents) async {
    ///FOLLOW UNFOLLOW PLAYLIST
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      await libraryDataProvider.followPlaylist(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      await libraryDataProvider.unFollowPlaylist(id);
    } else {
      throw "PLAYLIST FOLLOW UNFOLLOW OPERATION NOT VALID";
    }
  }

  void addRecentlyFollowedUnFollowedPlaylist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedPlaylistBox.delete(id);
      AppHiveBoxes.instance.recentlyFollowedPlaylistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox.delete(id);
      AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeFollowedUnFollowedPlaylist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedPlaylistBox.delete(id);
    }
  }

  void removeRecentlyFollowedUnFollowedPlaylist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedPlaylistBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedPlaylistBox.delete(id);
    }
  }

  ///FOR ARTIST
  Future<void> followUnFollowArtist(
      int id, AppLikeFollowEvents appLikeFollowEvents) async {
    ///FOLLOW UNFOLLOW ARTIST
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      await libraryDataProvider.followArtist(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      await libraryDataProvider.unFollowArtist(id);
    } else {
      throw "ARTIST FOLLOW UNFOLLOW OPERATION NOT VALID";
    }
  }

  void addRecentlyFollowedUnFollowedArtist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedArtistBox.delete(id);
      AppHiveBoxes.instance.recentlyFollowedArtistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedArtistBox.delete(id);
      AppHiveBoxes.instance.recentlyUnFollowedArtistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeFollowedUnFollowedArtist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedArtistBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedArtistBox.delete(id);
    }
  }

  void removeRecentlyFollowedUnFollowedArtist(
      int id, AppLikeFollowEvents appLikeFollowEvents) {
    if (appLikeFollowEvents == AppLikeFollowEvents.FOLLOW) {
      AppHiveBoxes.instance.recentlyFollowedArtistBox.delete(id);
    } else if (appLikeFollowEvents == AppLikeFollowEvents.UNFOLLOW) {
      AppHiveBoxes.instance.recentlyUnFollowedArtistBox.delete(id);
    }
  }

  cancelDio() {
    libraryDataProvider.cancel();
  }
}
