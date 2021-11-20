import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/util/l10n_util.dart';

import 'app_language_strings/app_language_strings_am.dart';
import 'app_language_strings/app_language_strings_en.dart';
import 'app_language_strings/app_language_strings_oro.dart';
import 'app_localizations.dart';

class AppLocale {
  static final AppLocale appLocale = AppLocale();
  static late AppLocalizations appLocalizations;

  static AppLocale of() {
    AppLanguage appLanguage = L10nUtil.getCurrentLocale();
    //print("LocalizationCubit=> appLanguage ${appLanguage}");
    if (appLanguage == AppLanguage.AMHARIC) {
      appLocalizations = AppLanguageStringsAm();
    } else if (appLanguage == AppLanguage.ENGLISH) {
      appLocalizations = AppLanguageStringsEn();
    } else if (appLanguage == AppLanguage.OROMIFA) {
      appLocalizations = AppLanguageStringsOro();
    } else {
      throw '$appLanguage LANGUAGE NOT SUPPORTED';
    }

    return appLocale;
  }

  String get appName => appLocalizations.appName;
  String get byAppName => appLocalizations.byAppName;
  String get appTermsAndCondition => appLocalizations.appTermsAndCondition;
  String get logOut => appLocalizations.logOut;
  String get byElfPlay => appLocalizations.byElfPlay;
  String get removeFromCart => appLocalizations.removeFromCart;
  String get addToCart => appLocalizations.addToCart;
  String get previewMode => appLocalizations.previewMode;
  String get buyMezmur => appLocalizations.buyMezmur;

  String get buyAlbum => appLocalizations.buyAlbum;
  String get buy => appLocalizations.buy;
  String get buyPlaylist => appLocalizations.buyPlaylist;
  String get buyMezmurToListenOffline =>
      appLocalizations.buyMezmurToListenOffline;
  String get follow => appLocalizations.follow;
  String get following => appLocalizations.following;
  String get addToFavorite => appLocalizations.addToFavorite;
  String get removeFromFavorite => appLocalizations.removeFromFavorite;

  String get followArtist => appLocalizations.followArtist;
  String get followPlaylist => appLocalizations.followPlaylist;
  String get removeFromFollowedPlaylist =>
      appLocalizations.removeFromFollowedPlaylist;
  String get uAreListingToPreviewDesc =>
      appLocalizations.uAreListingToPreviewDesc;
  String get downloadMezmur => appLocalizations.downloadMezmur;
  String get downloadProgressing => appLocalizations.downloadProgressing;
  String get retryDownload => appLocalizations.retryDownload;
  String get deleteMezmur => appLocalizations.deleteMezmur;
  String get shareAlbum => appLocalizations.shareAlbum;
  String get shareArtist => appLocalizations.shareArtist;

  String get sharePlaylist => appLocalizations.sharePlaylist;
  String get share => appLocalizations.share;
  String get shareMezmur => appLocalizations.shareMezmur;
  String get sortPlaylist => appLocalizations.sortPlaylist;
  String get findInPlaylist => appLocalizations.findInPlaylist;
  String get viewMezmursCategory => appLocalizations.viewMezmursCategory;
  String get viewArtist => appLocalizations.viewArtist;
  String get viewAlbum => appLocalizations.viewAlbum;
  String get addToQueue => appLocalizations.addToQueue;
  String get addToPlaylist => appLocalizations.addToPlaylist;

  String get removeFromPlaylistMsg => appLocalizations.removeFromPlaylistMsg;
  String get addMezmurs => appLocalizations.addMezmurs;
  String get addToHomeScreen => appLocalizations.addToHomeScreen;
  String get editPlaylist => appLocalizations.editPlaylist;
  String get deletePlaylist => appLocalizations.deletePlaylist;
  String get delete => appLocalizations.delete;
  String get cancel => appLocalizations.cancel;
  String get downloadingStr => appLocalizations.downloadingStr;
  String get noInternetMsg => appLocalizations.noInternetMsg;
  String get noInternetMsgDetail => appLocalizations.noInternetMsgDetail;
  String get tryAgain => appLocalizations.tryAgain;
  String get subscribeDialogTitle => appLocalizations.subscribeDialogTitle;
  String get subscribeDialogMsg => appLocalizations.subscribeDialogMsg;
  String get subscribeNow => appLocalizations.subscribeNow;

  String get home => appLocalizations.home;
  String get search => appLocalizations.search;
  String get myLibrary => appLocalizations.myLibrary;
  String get cart => appLocalizations.cart;
  String get libraryShort => appLocalizations.libraryShort;
  String get downAllPurchased => appLocalizations.downAllPurchased;
  String get yourOffline => appLocalizations.yourOffline;

  String get goToDownloadsMsg => appLocalizations.goToDownloadsMsg;
  String get free => appLocalizations.free;
  String get purchased => appLocalizations.purchased;
  String get albumBy => appLocalizations.albumBy;
  String get playingFromPlaylist => appLocalizations.playingFromPlaylist;
  String get playingFromAlbum => appLocalizations.playingFromAlbum;
  String get playingFromArtist => appLocalizations.playingFromArtist;
  String get playingFromCart => appLocalizations.playingFromCart;
  String get playingFromCategory => appLocalizations.playingFromCategory;
  String get playingFromFeaturedAlbum =>
      appLocalizations.playingFromFeaturedAlbum;

  String get playingFromFeaturedPlaylist =>
      appLocalizations.playingFromFeaturedPlaylist;
  String get playingFromFeaturedMezmurs =>
      appLocalizations.playingFromFeaturedMezmurs;
  String get playingFromRecentlyPlayed =>
      appLocalizations.playingFromRecentlyPlayed;
  String get playingFrom => appLocalizations.playingFrom;
  String get mostListened => appLocalizations.mostListened;
  String get verifiedArtist => appLocalizations.verifiedArtist;
  String get albums => appLocalizations.albums;
  String get playlists => appLocalizations.playlists;
  String get playlist => appLocalizations.playlist;

  String get mezmurs => appLocalizations.mezmurs;
  String get album => appLocalizations.album;
  String get category => appLocalizations.category;
  String get artists => appLocalizations.artists;
  String get popular => appLocalizations.popular;
  String get latestReleases => appLocalizations.latestReleases;
  String get topAlbums => appLocalizations.topAlbums;
  String get featuring => appLocalizations.featuring;
  String get similarArtist => appLocalizations.similarArtist;
  String get enterYourPhoneNumber => appLocalizations.enterYourPhoneNumber;
  String get whatIsYourPhoneNumber => appLocalizations.whatIsYourPhoneNumber;

  String get phoneVerificationMsg => appLocalizations.phoneVerificationMsg;
  String get sendSms => appLocalizations.sendSms;
  String get sendingSms => appLocalizations.sendingSms;
  String get continueWithPhoneNumber =>
      appLocalizations.continueWithPhoneNumber;
  String get searchForCountryCode => appLocalizations.searchForCountryCode;
  String get invalidPhoneNumber => appLocalizations.invalidPhoneNumber;
  String get noCountryCode => appLocalizations.noCountryCode;
  String get pinAlreadySent => appLocalizations.pinAlreadySent;
  String get verifying => appLocalizations.verifying;
  String get verify => appLocalizations.verify;
  String get pinNotFilled => appLocalizations.pinNotFilled;

  String get didntReciveSms => appLocalizations.didntReciveSms;
  String get resendCode => appLocalizations.resendCode;
  String get enterSixDigitMenu => appLocalizations.enterSixDigitMenu;
  String get enterYourCode => appLocalizations.enterYourCode;
  String get verifyYourPhone => appLocalizations.verifyYourPhone;
  String get continueWithApple => appLocalizations.continueWithApple;
  String get continueWithFacebook => appLocalizations.continueWithFacebook;
  String get continueWithGoogle => appLocalizations.continueWithGoogle;

  String get continueWithPhone => appLocalizations.continueWithPhone;
  String get appWelcomeTxt => appLocalizations.appWelcomeTxt;
  String get authenticationFailedMsg =>
      appLocalizations.authenticationFailedMsg;
  String get couldntConnectMsg => appLocalizations.couldntConnectMsg;
  String get queue => appLocalizations.queue;
  String get unableToClearCart => appLocalizations.unableToClearCart;
  String get cartCleared => appLocalizations.cartCleared;
  String get cartIsEmpty => appLocalizations.cartIsEmpty;
  String get empityCartCheckOutMsg => appLocalizations.empityCartCheckOutMsg;

  String get goToHomeScreen => appLocalizations.goToHomeScreen;
  String get cartTitle => appLocalizations.cartTitle;
  String get total => appLocalizations.total;
  String get checkOut => appLocalizations.checkOut;
  String get cartSummery => appLocalizations.cartSummery;
  String get remove => appLocalizations.remove;
  String get networkError => appLocalizations.networkError;
  String get emptyCategory => appLocalizations.emptyCategory;
  String get checkYourInternetConnection =>
      appLocalizations.checkYourInternetConnection;
  String get categories => appLocalizations.categories;
  String get featuredMezmurs => appLocalizations.featuredMezmurs;

  String get recentlyPlayed => appLocalizations.recentlyPlayed;
  String get purchasedMezmurs => appLocalizations.purchasedMezmurs;
  String get purchasedAlbums => appLocalizations.purchasedAlbums;
  String get purchasedPlaylists => appLocalizations.purchasedPlaylists;
  String get followedArtists => appLocalizations.followedArtists;
  String get followedPlaylists => appLocalizations.followedPlaylists;
  String get listenOffline => appLocalizations.listenOffline;
  String get noMezmursToPlay => appLocalizations.noMezmursToPlay;
  String get noAlbumsToSelect => appLocalizations.noAlbumsToSelect;
  String get myPlaylists => appLocalizations.myPlaylists;

  String get downloadAllPurchased => appLocalizations.downloadAllPurchased;
  String get sort => appLocalizations.sort;
  String get sortBy => appLocalizations.sortBy;
  String get latestDownloads => appLocalizations.latestDownloads;
  String get titleAz => appLocalizations.titleAz;
  String get artistAz => appLocalizations.artistAz;
  String get newest => appLocalizations.newest;
  String get oldest => appLocalizations.oldest;
  String get all => appLocalizations.all;

  String get noPlaylistToSelect => appLocalizations.noPlaylistToSelect;
  String get uDontHaveFavAlbums => appLocalizations.uDontHaveFavAlbums;
  String get uDontHaveFavMezmurs => appLocalizations.uDontHaveFavMezmurs;
  String get favoriteMezmurs => appLocalizations.favoriteMezmurs;
  String get uAreNotFollowingArtist => appLocalizations.uAreNotFollowingArtist;
  String get uAreNotFollowingPlaylist =>
      appLocalizations.uAreNotFollowingPlaylist;

  String get uHaventCreatedPlaylist => appLocalizations.uHaventCreatedPlaylist;
  String get createNewPlaylist => appLocalizations.createNewPlaylist;
  String get uDontHaveDownloads => appLocalizations.uDontHaveDownloads;
  String get offlineMezmurs => appLocalizations.offlineMezmurs;
  String get uDontHavePurchasedAlbums =>
      appLocalizations.uDontHavePurchasedAlbums;
  String get uDontHavePurchase => appLocalizations.uDontHavePurchase;
  String get uDontHavePurchasedPlaylists =>
      appLocalizations.uDontHavePurchasedPlaylists;
  String get uDontHavePurchasedMezmurs =>
      appLocalizations.uDontHavePurchasedMezmurs;
  String get autoDownload => appLocalizations.autoDownload;

  String get autoDownloadMsg => appLocalizations.autoDownloadMsg;
  String get newPlaylist => appLocalizations.newPlaylist;
  String get somethingWentWrong => appLocalizations.somethingWentWrong;
  String get offline => appLocalizations.offline;
  String get favorites => appLocalizations.favorites;
  String get refreshing => appLocalizations.refreshing;
  String get dailyQuotes => appLocalizations.dailyQuotes;
  String get lyrics => appLocalizations.lyrics;
  String get cantLoadLyrics => appLocalizations.cantLoadLyrics;
  String get playlistBy => appLocalizations.playlistBy;
  String get unableToUpdateProfile => appLocalizations.unableToUpdateProfile;

  String get profileUpdated => appLocalizations.profileUpdated;
  String get profileName => appLocalizations.profileName;
  String get chooseImage => appLocalizations.chooseImage;
  String get trackAPhoto => appLocalizations.trackAPhoto;
  String get pickFromGallery => appLocalizations.pickFromGallery;
  String get removeImage => appLocalizations.removeImage;
  String get changeImage => appLocalizations.changeImage;
  String get editProfile => appLocalizations.editProfile;
  String get userNameCantBeEmpty => appLocalizations.userNameCantBeEmpty;

  String get save => appLocalizations.save;
  String get notingToShow => appLocalizations.notingToShow;
  String get seeAll => appLocalizations.seeAll;
  String get purchases => appLocalizations.purchases;
  String get allCategories => appLocalizations.allCategories;
  String get topCategories => appLocalizations.topCategories;
  String get topMezmurs => appLocalizations.topMezmurs;
  String get topArtists => appLocalizations.topArtists;
  String get searchTitle => appLocalizations.searchTitle;
  String get changeYourSearchKey => appLocalizations.changeYourSearchKey;
  String get searchHint => appLocalizations.searchHint;
  String get searchHint2 => appLocalizations.searchHint2;
  String get searchElfFor => appLocalizations.searchElfFor;
  String get recentSearches => appLocalizations.recentSearches;

  String get clearRecentSearches => appLocalizations.clearRecentSearches;
  String get seeAllPlaylists => appLocalizations.seeAllPlaylists;
  String get seeAllAlbums => appLocalizations.seeAllAlbums;
  String get seeAllArtists => appLocalizations.seeAllArtists;
  String get seeAllMezmurs => appLocalizations.seeAllMezmurs;
  String get settings => appLocalizations.settings;
  String get dataSaver => appLocalizations.dataSaver;
  String get dataSaverMsg => appLocalizations.dataSaverMsg;
  String get preferredPaymentMethod => appLocalizations.preferredPaymentMethod;
  String get chooseYourPreferredMethod =>
      appLocalizations.chooseYourPreferredMethod;
  String get preferredDownlaodQuality =>
      appLocalizations.preferredDownlaodQuality;

  String get preferredDownlaodQualityMsg =>
      appLocalizations.preferredDownlaodQualityMsg;
  String get chooseYourLanguge => appLocalizations.chooseYourLanguge;
  String get reciveNotifications => appLocalizations.reciveNotifications;
  String get viewProfile => appLocalizations.viewProfile;
  String get couldntConnect => appLocalizations.couldntConnect;
  String get songAddedToFavorites => appLocalizations.songAddedToFavorites;
  String get songRemovedToFavorites => appLocalizations.songRemovedToFavorites;
  String get albumAddedToFavorites => appLocalizations.albumAddedToFavorites;
  String get albumRemovedToFavorites =>
      appLocalizations.albumRemovedToFavorites;
  String get playlistAddedToFavorites =>
      appLocalizations.playlistAddedToFavorites;
  String get playlistRemovedToFavorites =>
      appLocalizations.playlistRemovedToFavorites;
  String get artistsAddedToFavorites =>
      appLocalizations.artistsAddedToFavorites;

  String get artistsRemovedToFavorites =>
      appLocalizations.artistsRemovedToFavorites;
  String get albumAddedToCart => appLocalizations.albumAddedToCart;
  String get albumRemovedToCart => appLocalizations.albumRemovedToCart;
  String get songAddedToCart => appLocalizations.songAddedToCart;
  String get songRemovedToCart => appLocalizations.songRemovedToCart;
  String get playlistAddedToCart => appLocalizations.playlistAddedToCart;
  String get playlistRemovedToCart => appLocalizations.playlistRemovedToCart;
  String get by => appLocalizations.by;
  String get yourNotConnected => appLocalizations.yourNotConnected;
  String get helloCash => appLocalizations.helloCash;
  String get mbirr => appLocalizations.mbirr;
  String get cbeBirr => appLocalizations.cbeBirr;

  String get amole => appLocalizations.amole;
  String get visa => appLocalizations.visa;
  String get mastercard => appLocalizations.mastercard;
  String get alwaysUsePayment => appLocalizations.alwaysUsePayment;
  String get chooseYourPaymentMethod =>
      appLocalizations.chooseYourPaymentMethod;
  String get chooseYourPaymentMethodMsg =>
      appLocalizations.chooseYourPaymentMethodMsg;
  String get currentlySeletced => appLocalizations.currentlySeletced;
  String get selectPaymentMethod => appLocalizations.selectPaymentMethod;

  String get paymentMethod => appLocalizations.paymentMethod;
  String get selectYourPrefrredPayment =>
      appLocalizations.selectYourPrefrredPayment;
  String get unFollow => appLocalizations.unFollow;
  String get removeFromFollowedArtist =>
      appLocalizations.removeFromFollowedArtist;
  String get removeFromFavoriteMezmurs =>
      appLocalizations.removeFromFavoriteMezmurs;
  String get deletePlaylistPermanently =>
      appLocalizations.deletePlaylistPermanently;
  String get clearAll => appLocalizations.clearAll;
  String get areYouSureUWantToClearCart =>
      appLocalizations.areYouSureUWantToClearCart;
  String get goodMorning => appLocalizations.goodMorning;
  String get goodAfterNoon => appLocalizations.goodAfterNoon;
  String get goodEvening => appLocalizations.goodEvening;
  String get goodNight => appLocalizations.goodNight;

  String get nowPlaying => appLocalizations.nowPlaying;
  String get nextUp => appLocalizations.nextUp;
  String get pushNotifications => appLocalizations.pushNotifications;
  String get newReleases => appLocalizations.newReleases;
  String get latestUpdates => appLocalizations.latestUpdates;
  String get dailyCerlabrations => appLocalizations.dailyCerlabrations;
  String get unableToCreatePlaylist => appLocalizations.unableToCreatePlaylist;
  String get createPlaylist => appLocalizations.createPlaylist;
  String get addDescripption => appLocalizations.addDescripption;
  String get createPlaylistMsg => appLocalizations.createPlaylistMsg;
  String get playlistName => appLocalizations.playlistName;

  String get takeAPhoto => appLocalizations.takeAPhoto;
  String get removeIImage => appLocalizations.removeIImage;
  String get playlistNameCantBeEmpty =>
      appLocalizations.playlistNameCantBeEmpty;
  String get unableUpdatePlaylist => appLocalizations.unableUpdatePlaylist;
  String get addSomeDescription => appLocalizations.addSomeDescription;
  String get addDescription => appLocalizations.addDescription;
  String get addToExistingPlaylist => appLocalizations.addToExistingPlaylist;
  String get youHaventCreatedAnyPlaylistMsg =>
      appLocalizations.youHaventCreatedAnyPlaylistMsg;
  String get addToNewPlaylist => appLocalizations.addToNewPlaylist;
  String get unableToAddMezmur => appLocalizations.unableToAddMezmur;
  String get unableToRemoveFromPlaylist =>
      appLocalizations.unableToRemoveFromPlaylist;
  String get unableToDeletePlaylist => appLocalizations.unableToDeletePlaylist;
  String get addSongs => appLocalizations.addSongs;

  String get addSongsToPlaylist => appLocalizations.addSongsToPlaylist;
  String get dailyQuotesFromApp => appLocalizations.dailyQuotesFromApp;
  String get enablePermissions => appLocalizations.enablePermissions;
  String get enablePermissionsMsg => appLocalizations.enablePermissionsMsg;
  String get goToSystemSettings => appLocalizations.goToSystemSettings;
  String get cameraAccess => appLocalizations.cameraAccess;
  String get photoAccess => appLocalizations.photoAccess;

  String get rateApp => appLocalizations.rateApp;
  String get rateAppMsg => appLocalizations.rateAppMsg;
  String get areUSureWantToLogOut => appLocalizations.areUSureWantToLogOut;
  String get areUSureWantToLogOutMsg =>
      appLocalizations.areUSureWantToLogOutMsg;
  String get preferredCurrency => appLocalizations.preferredCurrency;
  String get preferredCurrencySettingMsg =>
      appLocalizations.preferredCurrencySettingMsg;
  String get shareApp => appLocalizations.shareApp;
  String get shareAppMsg => appLocalizations.shareAppMsg;

  String get retryingDownloadMsg => appLocalizations.retryingDownloadMsg;
  String get play => appLocalizations.play;
  String get onlyOnElf => appLocalizations.onlyOnElf;
  String get welcome => appLocalizations.welcome;
  String get google => appLocalizations.google;
  String get facebook => appLocalizations.facebook;
  String get apple => appLocalizations.apple;

  ///FUNCTIONS
  String noOfSongs({required String noOfSong}) =>
      appLocalizations.noOfSongs(noOfSong: noOfSong);

  String downloading({required String songName}) =>
      appLocalizations.downloading(songName: songName);

  String searchDedicatedTitle(
          {required String searchKey, required String appItemType}) =>
      appLocalizations.searchDedicatedTitle(
        appItemType: appItemType,
        searchKey: searchKey,
      );

  String cantFind({required String searchKey}) =>
      appLocalizations.cantFind(searchKey: searchKey);

  String areUSureYouWantToDeleteFromDownloads({required String songName}) =>
      appLocalizations.areUSureYouWantToDeleteFromDownloads(songName: songName);

  String songRemoveFromPlaylist({required String songName}) =>
      appLocalizations.songRemoveFromPlaylist(songName: songName);

  String areYouSureUwantDeleteFromDownloads({required String songName}) =>
      appLocalizations.areYouSureUwantDeleteFromDownloads(songName: songName);

  String downloadComplete({required String songName}) =>
      appLocalizations.downloadComplete(songName: songName);

  String preferredPaymentChangedTo({required String paymentName}) =>
      appLocalizations.preferredPaymentChangedTo(paymentName: paymentName);

  String popularSongsBy({required String artistName}) =>
      appLocalizations.popularSongsBy(artistName: artistName);

  String playlistUpdated({required String playlistName}) =>
      appLocalizations.playlistUpdated(playlistName: playlistName);

  String playlistCreated({required String playlistName}) =>
      appLocalizations.playlistCreated(playlistName: playlistName);

  String songAddedToPlaylist(
          {required String songName, required String playlistName}) =>
      appLocalizations.songAddedToPlaylist(
          playlistName: playlistName, songName: songName);

  String songRemovedPlaylist(
          {required String songName, required String playlistName}) =>
      appLocalizations.songRemovedPlaylist(
          playlistName: playlistName, songName: songName);

  String playlistDeleted({required String playlistName}) =>
      appLocalizations.playlistDeleted(playlistName: playlistName);

  String unableToRemoveFromCart({required String unabledName}) =>
      appLocalizations.unableToRemoveFromCart(unabledName: unabledName);

  String playingFromSearchResult({required String searchKey}) =>
      appLocalizations.playingFromSearchResult(searchKey: searchKey);

  String playingFromArtistName({required String artistName}) =>
      appLocalizations.playingFromArtistName(artistName: artistName);

  String byUserName({required String userName}) =>
      appLocalizations.byUserName(userName: userName);

  String noOfAlbum({required String noOfAlbums}) =>
      appLocalizations.noOfAlbum(noOfAlbums: noOfAlbums);

  String numberOfFollowers({required String numberOf}) =>
      appLocalizations.numberOfFollowers(numberOf: numberOf);

  String numberOfMezmurs({required String numberOf}) =>
      appLocalizations.numberOfMezmurs(numberOf: numberOf);

  String removeedFromCart({required String removedName}) =>
      appLocalizations.removedFromCart(removedName: removedName);

  String appNameAndVersion({required String versionCode}) =>
      appLocalizations.appNameAndVersion(versionCode: versionCode);

  String appVersion({required String versionCode}) =>
      appLocalizations.appNameAndVersion(versionCode: versionCode);
}
