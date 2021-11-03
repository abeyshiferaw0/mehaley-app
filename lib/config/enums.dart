import 'package:elf_play/util/enum_values.dart';

enum GroupType { SONG, PLAYLIST, ARTIST, ALBUM }

enum GroupUiType { LINEAR_HORIZONTAL, LINEAR_HORIZONTAL_WITH_HEADER, GRID_VERTICAL }

enum AppItemsType { ALBUM, ARTIST, SINGLE_TRACK, PLAYLIST, GROUP, OTHER, CATEGORY }

enum SearchResultOtherItems {
  SEE_ALL_PLAYLISTS,
  SEE_ALL_ALBUMS,
  SEE_ALL_SONGS,
  SEE_ALL_ARTISTS,
  BLANK_SPACE,
}

enum AppSearchItemTypes { ALBUM, ARTIST, SONG, PLAYLIST }

enum AppCacheStrategy { NO_CACHE, LOAD_CACHE_FIRST, CACHE_LATER }

enum BottomBarPages { HOME, SEARCH, LIBRARY, CART }

final groupTypeEnumValues = EnumValues({
  "SONG": GroupType.SONG,
  "PLAYLIST": GroupType.PLAYLIST,
  "ARTIST": GroupType.ARTIST,
});

enum AppLanguageOptions { ENGLISH, AMHARIC, OROMIFA, TIGRINYA }

enum AppLikeFollowEvents { LIKE, UNLIKE, FOLLOW, UNFOLLOW }

enum AppCartAddRemoveEvents { ADD, REMOVE }

enum AppPaymentMethod { TYPE_ONE, TYPE_TWO, TYPE_THREE }

enum AppCurrency { ETB, DOLLAR }

enum AppPurchasedPageItemTypes { ALL_SONGS, SONGS, ALBUMS, PLAYLISTS }

enum AppFavoritePageItemTypes { SONGS, ALBUMS }

enum AppFollowedPageItemTypes { ARTIST, PLAYLISTS }

enum AppUserImageType { SOCIAL_IMAGE, PROFILE_IMAGE, NONE }

enum AppLibrarySortTypes {
  TITLE_A_Z,
  ARTIST_A_Z,
  NEWEST,
  OLDEST,
  LATEST_DOWNLOAD,
}

enum ProfileListTypes {
  PURCHASED_SONGS,
  PURCHASED_ALBUMS,
  PURCHASED_PLAYLISTS,
  FOLLOWED_ARTISTS,
  FOLLOWED_PLAYLISTS,
  OTHER,
}

enum AppUserNotificationTypes {
  RECEIVE_ADMIN_NOTIFICATIONS,
  RECEIVE_NEW_RELEASES_NOTIFICATIONS,
  RECEIVE_LATEST_UPDATES_NOTIFICATIONS,
  RECEIVE_DAILY_CEREMONIES_NOTIFICATIONS,
}
