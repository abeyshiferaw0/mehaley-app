import 'package:elf_play/data/data_providers/album_data_provider.dart';
import 'package:elf_play/data/data_providers/artist_data_provider.dart';
import 'package:elf_play/data/data_providers/auth_provider.dart';
import 'package:elf_play/data/data_providers/category_data_provider.dart';
import 'package:elf_play/data/data_providers/home_data_provider.dart';
import 'package:elf_play/data/data_providers/library_data_provider.dart';
import 'package:elf_play/data/data_providers/library_page_data_provider.dart';
import 'package:elf_play/data/data_providers/lyric_data_provider.dart';
import 'package:elf_play/data/data_providers/playlist_data_provider.dart';
import 'package:elf_play/data/data_providers/search_data_provider.dart';
import 'package:elf_play/data/data_providers/settings_data_provider.dart';
import 'package:elf_play/data/data_providers/song_menu_data_provider.dart';
import 'package:elf_play/data/repositories/album_data_repository.dart';
import 'package:elf_play/data/repositories/artist_data_repository.dart';
import 'package:elf_play/data/repositories/auth_repository.dart';
import 'package:elf_play/data/repositories/category_data_repository.dart';
import 'package:elf_play/data/repositories/home_data_repository.dart';
import 'package:elf_play/data/repositories/library_data_repository.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:elf_play/data/repositories/lyric_data_repository.dart';
import 'package:elf_play/data/repositories/player_data_repository.dart';
import 'package:elf_play/data/repositories/playlist_data_repository.dart';
import 'package:elf_play/data/repositories/search_data_repository.dart';
import 'package:elf_play/data/repositories/setting_data_repository.dart';
import 'package:elf_play/data/repositories/song_menu_repository.dart';

class AppRepositories {
  //REPOSITORIES
  static ArtistDataRepository artistDataRepository = ArtistDataRepository(
    artistDataProvider: ArtistDataProvider(),
  );

  static SearchDataRepository searchDataRepository = SearchDataRepository(
    searchDataProvider: SearchDataProvider(),
  );

  static HomeDataRepository homeDataRepository = HomeDataRepository(
    homeDataProvider: HomeDataProvider(),
  );
  static CategoryDataRepository categoryDataRepository = CategoryDataRepository(
    categoryDataProvider: CategoryDataProvider(),
  );
  static AlbumDataRepository albumDataRepository = AlbumDataRepository(
    albumDataProvider: AlbumDataProvider(),
  );
  static PlaylistDataRepository playlistDataRepository = PlaylistDataRepository(
    playlistDataProvider: PlaylistDataProvider(),
  );
  static LyricDataRepository lyricDataRepository = LyricDataRepository(
    lyricDataProvider: LyricDataProvider(),
  );

  static SongMenuRepository songMenuRepository = SongMenuRepository(
    songMenuDataProvider: SongMenuDataProvider(),
  );

  static AuthRepository authRepository = AuthRepository(
    authProvider: AuthProvider(),
  );

  static LibraryDataRepository libraryDataRepository = LibraryDataRepository(
    libraryDataProvider: LibraryDataProvider(),
  );

  static LibraryPageDataRepository libraryPageDataRepository =
      LibraryPageDataRepository(
    libraryPageDataProvider: LibraryPageDataProvider(),
  );

  static PlayerDataRepository playerDataRepository = PlayerDataRepository();

  static SettingDataRepository settingDataRepository = SettingDataRepository(
    settingsDataProvider: SettingsDataProvider(),
  );
}
