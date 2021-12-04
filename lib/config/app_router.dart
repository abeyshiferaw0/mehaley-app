import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/album_page_bloc/album_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/artist_page_bloc/artist_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/category_page_bloc/category_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/category_page_bloc/category_page_pagination_bloc.dart';
import 'package:mehaley/business_logic/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/playlist_page_bloc/playlist_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/profile_page/profile_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:mehaley/business_logic/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/front_page_bloc/search_front_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/search_page_bloc/search_result_bloc/search_result_bloc.dart';
import 'package:mehaley/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_page_bloc/user_playlist_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/purchased_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/search_cancel_cubit.dart';
import 'package:mehaley/business_logic/cubits/search_page_dominant_color_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/ui/screens/album/album_page.dart';
import 'package:mehaley/ui/screens/artist/artist_page.dart';
import 'package:mehaley/ui/screens/cart/cart_page.dart';
import 'package:mehaley/ui/screens/category/category_page.dart';
import 'package:mehaley/ui/screens/home/home_page.dart';
import 'package:mehaley/ui/screens/library/library_page.dart';
import 'package:mehaley/ui/screens/player/player_page.dart';
import 'package:mehaley/ui/screens/playlist/playlist_page.dart';
import 'package:mehaley/ui/screens/profile/profile_page.dart';
import 'package:mehaley/ui/screens/search/search_page.dart';
import 'package:mehaley/ui/screens/search/search_result_dedicated.dart';
import 'package:mehaley/ui/screens/search/search_result_page.dart';
import 'package:mehaley/ui/screens/setting/settings_page.dart';
import 'package:mehaley/ui/screens/user_playlist/user_playlist_page.dart';
import 'package:mehaley/ui/screens/wallet/wallet_page.dart';

import 'constants.dart';

class ScreenArguments {
  final Map<String, dynamic> args;

  ScreenArguments({required this.args});
}

class AppRouterPaths {
  static const String splashRoute = '/';
  static const String signUp = '/sign_up';
  static const String verifyPhonePageOne = '/verify_phone_page_one';
  static const String verifyPhonePageTwo = '/verify_phone_page_two';
  static const String mainScreen = '/main_screen';
  static const String homeRoute = 'home';
  static const String settingRoute = '/setting';
  static const String profileRoute = '/profile';
  static const String walletPage = '/wallet_page';
  static const String editProfileRoute = '/edit_profile';
  static const String albumRoute = '/album';
  static const String playlistRoute = '/playlist';
  static const String userPlaylistRoute = '/user_playlist';
  static const String playerRoute = '/player';
  static const String artistRoute = '/artist';
  static const String libraryRoute = '/library';
  static const String createPlaylistRoute = '/create_playlist';
  static const String categoryRoute = '/category';
  static const String searchRoute = '/search';
  static const String searchResultRoute = '/search_result';
  static const String searchResultDedicatedRoute = '/search_result_dedicated';
  static const String cartRoute = '/cart';
  static const String songAddToPlaylist = '/song_add_to_playlist';

  //ROUTE OBSERVER
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();
}

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    //BUILDER
    WidgetBuilder builder;
    //ROUTERS PATH SWITCH
    switch (settings.name) {
      case AppRouterPaths.homeRoute:
        builder = (_) => BlocProvider<HomePageBloc>(
              create: (context) => HomePageBloc(
                homeDataRepository: AppRepositories.homeDataRepository,
              ),
              child: HomePage(
                key: Key('HOME_PAGE_KEY'),
              ),
            );
        break;
      case AppRouterPaths.settingRoute:
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SettingsPageBloc(
                    settingDataRepository:
                        AppRepositories.settingDataRepository,
                  ),
                ),
              ],
              child: SettingsPage(),
            );
        break;
      case AppRouterPaths.profileRoute:
        builder = (_) => BlocProvider(
              create: (context) => ProfilePageBloc(
                profileDataRepository: AppRepositories.profileDataRepository,
              ),
              child: ProfilePage(),
            );
        break;
      case AppRouterPaths.playerRoute:
        builder = (_) => BlocProvider(
              create: (context) => QuotesBloc(
                quotesDataRepository: AppRepositories.quotesDataRepository,
              ),
              child: PlayerPage(),
            );
        break;
      case AppRouterPaths.albumRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => BlocProvider<AlbumPageBloc>(
              create: (context) => AlbumPageBloc(
                albumDataRepository: AppRepositories.albumDataRepository,
              ),
              child: AlbumPage(albumId: args.args['albumId']),
            );
        break;
      case AppRouterPaths.playlistRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => BlocProvider<PlaylistPageBloc>(
              create: (context) => PlaylistPageBloc(
                playlistDataRepository: AppRepositories.playlistDataRepository,
              ),
              child: PlaylistPage(playlistId: args.args['playlistId']),
            );
        break;
      case AppRouterPaths.userPlaylistRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider<UserPlaylistPageBloc>(
                  create: (context) => UserPlaylistPageBloc(
                    userPLayListRepository:
                        AppRepositories.userPLayListRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => UserPlaylistBloc(
                    userPLayListRepository:
                        AppRepositories.userPLayListRepository,
                  ),
                ),
              ],
              child: UserPlaylistPage(playlistId: args.args['playlistId']),
            );
        break;
      // case AppRouterPaths.editProfileRoute:
      //   builder = (_) => MultiBlocProvider(
      //         providers: [
      //           BlocProvider<ImagePickerCubit>(
      //             create: (context) => ImagePickerCubit(
      //               picker: ImagePicker(),
      //             ),
      //           ),
      //           BlocProvider<AuthBloc>(
      //             create: (context) => AuthBloc(
      //               firebaseAuth: FirebaseAuth.instance,
      //               authRepository: AppRepositories.authRepository,
      //             ),
      //           ),
      //         ],
      //         child: EditUserProfilePage(),
      //       );
      //   break;
      case AppRouterPaths.artistRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => BlocProvider(
            create: (context) => ArtistPageBloc(
                  artistDataRepository: AppRepositories.artistDataRepository,
                ),
            child: ArtistPage(artistId: args.args['artistId']));
        break;
      case AppRouterPaths.libraryRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => FollowingTabPagesCubit(),
                ),
                BlocProvider(
                  create: (context) => PurchasedTabPagesCubit(),
                ),
                BlocProvider(
                  create: (context) => LibraryTabPagesCubit(),
                ),
                BlocProvider(
                  create: (context) => UserPlaylistBloc(
                    userPLayListRepository:
                        AppRepositories.userPLayListRepository,
                  ),
                ),
              ],
              child: LibraryPage(
                isFromOffline: args.args[AppValues.isLibraryForOffline],
                isLibraryForProfile: args.args[AppValues.isLibraryForProfile],
                profileListTypes: args.args[AppValues.profileListTypes],
              ),
            );
        break;
      case AppRouterPaths.categoryRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider<CategoryPageBloc>(
                  create: (context) => CategoryPageBloc(
                    categoryDataRepository:
                        AppRepositories.categoryDataRepository,
                  ),
                ),
                BlocProvider<CategoryPagePaginationBloc>(
                  create: (context) => CategoryPagePaginationBloc(
                      categoryDataRepository:
                          AppRepositories.categoryDataRepository),
                ),
              ],
              child: CategoryPage(category: args.args['category']),
            );

        break;
      case AppRouterPaths.searchRoute:
        builder = (_) => BlocProvider(
              create: (context) => SearchFrontPageBloc(
                searchDataRepository: AppRepositories.searchDataRepository,
              ),
              child: SearchPage(),
            );
        break;
      case AppRouterPaths.searchResultRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SearchResultBloc(
                    searchDataRepository: AppRepositories.searchDataRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => SearchPageDominantColorCubit(
                    searchResultBloc:
                        BlocProvider.of<SearchResultBloc>(context),
                  ),
                ),
                BlocProvider(
                  create: (context) => RecentSearchBloc(),
                ),
                BlocProvider(
                  create: (context) => SearchCancelCubit(),
                ),
              ],
              child:
                  SearchResultPage(isVoiceTyping: args.args['isVoiceTyping']),
            );
        break;
      case AppRouterPaths.searchResultDedicatedRoute:
        final args = settings.arguments as ScreenArguments;
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => RecentSearchBloc(),
                ),
                BlocProvider(
                  create: (context) => SearchResultBloc(
                    searchDataRepository: AppRepositories.searchDataRepository,
                  ),
                )
              ],
              child: SearchResultDedicated(
                searchKey: args.args['searchKey'],
                appSearchItemTypes: args.args['appSearchItemTypes'],
              ),
            );
        break;
      case AppRouterPaths.cartRoute:
        builder = (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CartPageBloc(
                    cartRepository: AppRepositories.cartRepository,
                  ),
                ),
              ],
              child: CartPage(),
            );
        break;
      case AppRouterPaths.walletPage:
        builder = (_) => BlocProvider(
              create: (context) => WalletPageBloc(
                walletDataRepository: AppRepositories.walletDataRepository,
              ),
              child: WalletPage(),
            );
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    //BUILDER  WITH ROUTERS
    return CupertinoPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
