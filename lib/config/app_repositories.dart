import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/album_data_provider.dart';
import 'package:mehaley/data/data_providers/artist_data_provider.dart';
import 'package:mehaley/data/data_providers/auth_provider.dart';
import 'package:mehaley/data/data_providers/cart_data_provider.dart';
import 'package:mehaley/data/data_providers/category_data_provider.dart';
import 'package:mehaley/data/data_providers/home_data_provider.dart';
import 'package:mehaley/data/data_providers/library_page_data_provider.dart';
import 'package:mehaley/data/data_providers/like_follow_provider.dart';
import 'package:mehaley/data/data_providers/lyric_data_provider.dart';
import 'package:mehaley/data/data_providers/my_playlist_data_provider.dart';
import 'package:mehaley/data/data_providers/payment_provider.dart';
import 'package:mehaley/data/data_providers/playlist_data_provider.dart';
import 'package:mehaley/data/data_providers/profile_data_provider.dart';
import 'package:mehaley/data/data_providers/quotes_data_provider.dart';
import 'package:mehaley/data/data_providers/search_data_provider.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/data_providers/song_menu_data_provider.dart';
import 'package:mehaley/data/data_providers/sync_provider.dart';
import 'package:mehaley/data/data_providers/user_playlist_data_provider.dart';
import 'package:mehaley/data/data_providers/wallet_data_provider.dart';
import 'package:mehaley/data/repositories/album_data_repository.dart';
import 'package:mehaley/data/repositories/artist_data_repository.dart';
import 'package:mehaley/data/repositories/auth_repository.dart';
import 'package:mehaley/data/repositories/cart_data_repository.dart';
import 'package:mehaley/data/repositories/category_data_repository.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';
import 'package:mehaley/data/repositories/library_page_data_repository.dart';
import 'package:mehaley/data/repositories/like_follow_repository.dart';
import 'package:mehaley/data/repositories/lyric_data_repository.dart';
import 'package:mehaley/data/repositories/my_playlist_repository.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';
import 'package:mehaley/data/repositories/playlist_data_repository.dart';
import 'package:mehaley/data/repositories/profile_data_repository.dart';
import 'package:mehaley/data/repositories/quotes_data_repository.dart';
import 'package:mehaley/data/repositories/search_data_repository.dart';
import 'package:mehaley/data/repositories/setting_data_repository.dart';
import 'package:mehaley/data/repositories/song_menu_repository.dart';
import 'package:mehaley/data/repositories/sync_repository.dart';
import 'package:mehaley/data/repositories/user_playlist_repository.dart';
import 'package:mehaley/data/repositories/wallet_data_repository.dart';

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
    lyricDataProvider: LyricDataProvider(cancelToken: CancelToken()),
  );

  static SongMenuRepository songMenuRepository = SongMenuRepository(
    songMenuDataProvider: SongMenuDataProvider(),
  );

  static AuthRepository authRepository = AuthRepository(
    authProvider: AuthProvider(),
  );

  static LikeFollowRepository libraryDataRepository = LikeFollowRepository(
    libraryDataProvider: LikeFollowProvider(),
  );

  static LibraryPageDataRepository libraryPageDataRepository =
      LibraryPageDataRepository(
    libraryPageDataProvider: LibraryPageDataProvider(),
  );

  static SettingDataRepository settingDataRepository = SettingDataRepository(
    settingsDataProvider: SettingsDataProvider(),
  );

  static MyPLayListRepository myPlayListRepository = MyPLayListRepository(
    myPLayListDataProvider: MyPlaylistDataProvider(),
  );

  static UserPLayListRepository userPLayListRepository = UserPLayListRepository(
    userPlaylistDataProvider: UserPlaylistDataProvider(),
  );

  static CartRepository cartRepository = CartRepository(
    cartDataProvider: CartDataProvider(),
  );

  static ProfileDataRepository profileDataRepository = ProfileDataRepository(
    profileDataProvider: ProfileDataProvider(),
  );

  static SyncRepository syncSongRepository = SyncRepository(
    syncProvider: SyncProvider(),
  );

  static PaymentRepository paymentRepository = PaymentRepository(
    paymentProvider: PaymentProvider(),
  );

  static QuotesDataRepository quotesDataRepository = QuotesDataRepository(
    quotesDataProvider: QuotesDataProvider(),
  );

  static WalletDataRepository walletDataRepository = WalletDataRepository(
    walletDataProvider: WalletDataProvider(),
  );

}
