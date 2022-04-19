enum AppType {
  MEHALEYE,
  ELF_PLAY,
}

enum GroupType { SONG, PLAYLIST, ARTIST, ALBUM, NONE }

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

enum AppShareTypes { ALBUM, ARTIST, SONG, PLAYLIST, OTHER }

enum AppCacheStrategy { NO_CACHE, LOAD_CACHE_FIRST, CACHE_LATER }

enum BottomBarPages { HOME, SEARCH, LIBRARY, SUBSCRIPTION, PROFILE }

enum AppLikeFollowEvents { LIKE, UNLIKE, FOLLOW, UNFOLLOW }

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

enum LibraryFromOtherPageTypes {
  PURCHASED_SONGS,
  PURCHASED_ALL_SONGS,
  PURCHASED_ALBUMS,
  PURCHASED_PLAYLISTS,
  FOLLOWED_ARTISTS,
  FOLLOWED_PLAYLISTS,
  USER_PLAYLIST,
}

enum AppUserNotificationTypes {
  RECEIVE_ADMIN_NOTIFICATIONS,
  RECEIVE_NEW_RELEASES_NOTIFICATIONS,
  RECEIVE_LATEST_UPDATES_NOTIFICATIONS,
  RECEIVE_DAILY_CEREMONIES_NOTIFICATIONS,
}

enum PaymentStatus {
  NOT_PAID,
  PAID_NOT_CONFIRMED,
  PAID_CONFIRMED,
  CANCELED,
}

enum PurchasedItemType {
  SONG_PAYMENT,
  ALBUM_PAYMENT,
  PLAYLIST_PAYMENT,
}

enum AppVideoItemAction {
  SHARE,
  OPEN_AUDIO
  //OPEN_WITH_YOUTUBE,
}

enum AppPurchasedItemType {
  SONG_PAYMENT,
  ALBUM_PAYMENT,
  PLAYLIST_PAYMENT,
}

enum AppPurchasedSources {
  MINI_PLAYER_BUY_BUTTON_ON_CLICK,
  SONG_MENU_BUY_BUTTON_ON_CLICK,
  SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
  PLAYLIST_PAGE_HEADER_BUY_BUTTON_ON_CLICK,
  PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
  ALBUM_PAGE_HEADER_BUY_BUTTON_ON_CLICK,
  ALBUM_MENU_BUY_BUTTON_ON_CLICK,
}

enum AppAddEmbedPlace {
  HOME_PAGE_TOP,
  HOME_PAGE_MIDDLE,
  HOME_PAGE_BOTTOM,
  PLAYER_PAGE_ALBUM_ART
}

enum AppAdAction {
  CALL,
  LAUNCH_URL,
}

enum YenepayPaymentReturnType { COMPLETED, FAILURE, CANCEL, IS_FREE, EXISTS }

enum HomePageTabs { EXPLORE, ALL_SONGS, ALL_ALBUMS, ALL_ARTISTS, ALL_PLAYLISTS }
