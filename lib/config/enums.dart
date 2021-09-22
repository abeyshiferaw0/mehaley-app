import 'package:elf_play/util/enum_values.dart';

enum GroupType { SONG, PLAYLIST, ARTIST, ALBUM }

enum GroupUiType {
  LINEAR_HORIZONTAL,
  LINEAR_HORIZONTAL_WITH_HEADER,
  GRID_VERTICAL
}

enum AppItemsType {
  ALBUM,
  ARTIST,
  SINGLE_TRACK,
  PLAYLIST,
  GROUP,
  OTHER,
  CATEGORY
}

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

enum AppPaymentMethod { TYPE_ONE, TYPE_TWO, TYPE_THREE }

enum AppCurrency { ETB, DOLLAR }

enum AppPurchasedPageItemTypes { ALL_SONGS, SONGS, ALBUMS, PLAYLISTS }

enum AppFavoritePageItemTypes { SONGS, ALBUMS }

enum AppFollowedPageItemTypes { ARTIST, PLAYLISTS }
