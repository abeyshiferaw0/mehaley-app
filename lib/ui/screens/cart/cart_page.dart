import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cart_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/cart_page_data.dart';
import 'package:mehaley/data/models/cart/cart.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/cart/widgets/cart_app_bar.dart';
import 'package:mehaley/ui/screens/cart/widgets/cart_appbar_delegate.dart';
import 'package:mehaley/ui/screens/cart/widgets/cart_clear_and_check_delegate.dart';
import 'package:mehaley/ui/screens/cart/widgets/cart_summery.dart';
import 'package:mehaley/ui/screens/cart/widgets/list_cart_albums.dart';
import 'package:mehaley/ui/screens/cart/widgets/list_cart_playlist.dart';
import 'package:mehaley/ui/screens/cart/widgets/list_cart_songs.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with RouteAware {
  void didChangeDependencies() {
    super.didChangeDependencies();
    //SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context).changeScreen(BottomBarPages.CART);
    BlocProvider.of<BottomBarCartCubit>(context).setPageShowing(true);
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarCartCubit>(context).setPageShowing(false);
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarCartCubit>(context).setPageShowing(false);
    super.didPop();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    ///CHANGE BOTTOM BAR TO CART PAGE
    BlocProvider.of<BottomBarCubit>(context).changeScreen(
      BottomBarPages.CART,
    );

    ///LOAD CART PAGE
    BlocProvider.of<CartPageBloc>(context).add(
      LoadCartPageEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartUtilBloc, CartUtilState>(
      listener: (context, state) {
        ///ERROR MESSAGES WHEN REMOVING FROM CART
        if (state is CartUtilSongAddingErrorState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD)
            return;
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.black,
              isFloating: false,
              msg: AppLocale.of().unableToRemoveFromCart(
                  unabledName:
                      L10nUtil.translateLocale(state.song.songName, context)),
              txtColor: AppColors.white,
              icon: PhosphorIcons.wifi_x_light,
              iconColor: AppColors.errorRed,
            ),
          );
        }
        if (state is CartUtilAlbumAddingErrorState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD)
            return;
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.black,
              isFloating: false,
              msg: AppLocale.of().unableToRemoveFromCart(
                  unabledName: L10nUtil.translateLocale(
                      state.album.albumTitle, context)),
              txtColor: AppColors.white,
              icon: PhosphorIcons.wifi_x_light,
              iconColor: AppColors.errorRed,
            ),
          );
        }
        if (state is CartUtilPlaylistAddingErrorState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD)
            return;
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.black,
              isFloating: false,
              msg: AppLocale.of().unableToRemoveFromCart(
                unabledName: L10nUtil.translateLocale(
                  state.playlist.playlistNameText,
                  context,
                ),
              ),
              txtColor: AppColors.white,
              icon: PhosphorIcons.wifi_x_light,
              iconColor: AppColors.errorRed,
            ),
          );
        }
        if (state is CartAllRemovingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.black,
              isFloating: false,
              msg: AppLocale.of().unableToClearCart,
              txtColor: AppColors.white,
              icon: PhosphorIcons.wifi_x_light,
              iconColor: AppColors.errorRed,
            ),
          );
        }

        ///SUCCESS MESSAGES WHEN REMOVING
        if (state is CartUtilSongAddedSuccessState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
            ///LOAD CART WITHOUT REMOVED SONG
            BlocProvider.of<CartPageBloc>(context).add(
              LoadCartPageEvent(
                isForRemoved: false,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              buildDownloadMsgSnackBar(
                  bgColor: AppColors.black,
                  isFloating: true,
                  msg: AppLocale.of().removeedFromCart(
                      removedName: L10nUtil.translateLocale(
                          state.song.songName, context)),
                  txtColor: AppColors.white,
                  icon: PhosphorIcons.check_circle_fill,
                  iconColor: AppColors.darkOrange),
            );

            ///LOAD CART WITHOUT REMOVED SONG
            BlocProvider.of<CartPageBloc>(context).add(
              LoadCartPageEvent(
                isForRemoved: true,
                song: state.song,
              ),
            );
          }
        }

        if (state is CartUtilAlbumAddedSuccessState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD)
            return;
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
                bgColor: AppColors.black,
                isFloating: true,
                msg: AppLocale.of().removeedFromCart(
                    removedName: L10nUtil.translateLocale(
                        state.album.albumTitle, context)),
                txtColor: AppColors.white,
                icon: PhosphorIcons.check_circle_fill,
                iconColor: AppColors.darkOrange),
          );

          ///LOAD CART WITHOUT REMOVED ALBUM
          BlocProvider.of<CartPageBloc>(context).add(
            LoadCartPageEvent(
              isForRemoved: true,
              album: state.album,
            ),
          );
        }

        if (state is CartUtilPlaylistAddedSuccessState) {
          if (state.appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD)
            return;
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
                bgColor: AppColors.black,
                isFloating: true,
                msg: AppLocale.of().removeedFromCart(
                  removedName: L10nUtil.translateLocale(
                    state.playlist.playlistNameText,
                    context,
                  ),
                ),
                txtColor: AppColors.white,
                icon: PhosphorIcons.check_circle_fill,
                iconColor: AppColors.darkOrange),
          );

          ///LOAD CART WITHOUT REMOVED PLAYLIST
          BlocProvider.of<CartPageBloc>(context).add(
            LoadCartPageEvent(
              isForRemoved: true,
              playlist: state.playlist,
            ),
          );
        }

        if (state is CartAllRemovedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
                bgColor: AppColors.black,
                isFloating: true,
                msg: AppLocale.of().cartCleared,
                txtColor: AppColors.white,
                icon: PhosphorIcons.check_circle_fill,
                iconColor: AppColors.darkOrange),
          );

          ///LOAD CART WITHOUT REMOVED PLAYLIST
          BlocProvider.of<CartPageBloc>(context).add(
            LoadCartPageEvent(
              isForRemoved: false,
            ),
          );
        }
      },
      child: BlocBuilder<CartPageBloc, CartPageState>(
        builder: (context, state) {
          if (state is CartPageLoadingState) {
            return buildPageLoading();
          }
          if (state is CartPageLoadedState) {
            if (cartIsEmpty(state.cartPageData)) {
              return buildPageEmpty();
            }
            return buildPageLoaded(state.cartPageData.cart);
          }
          if (state is CartPageLoadingErrorState) {
            return buildPageLoadingError();
          }
          return buildPageLoading();
        },
      ),
    );
  }

  Scaffold buildPageLoaded(Cart cart) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.darkOrange,
        onRefresh: () async {
          ///LOAD CART PAGE
          BlocProvider.of<CartPageBloc>(context).add(
            LoadCartPageEvent(),
          );
          await BlocProvider.of<CartPageBloc>(context).stream.first;
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                ///CART PAGE APPBAR
                SliverPersistentHeader(
                  floating: true,
                  pinned: false,
                  delegate: CartAppBarDelegate(
                    height:
                        ScreenUtil(context: context).getScreenHeight() * 0.1,
                    cart: cart,
                  ),
                ),

                ///CART PAGE CHECK OUT HEADER
                SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  delegate: ClearAndCheckDelegate(),
                ),

                ///CART PAGE SUMMERY HEADER
                SliverToBoxAdapter(
                  child: CartSummery(),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppMargin.margin_12,
                  ),
                ),

                ///CART ALBUMS LIST
                SliverToBoxAdapter(
                  child: CartAlbumsList(
                    albumCart: cart.albumCart,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppMargin.margin_12,
                  ),
                ),

                ///CART PLAYLISTS LIST
                SliverToBoxAdapter(
                  child: CartPlaylistsList(
                    playlistCart: cart.playlistCart,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppMargin.margin_16,
                  ),
                ),

                ///CART SONGS LIST
                SliverToBoxAdapter(
                  child: CartSongsList(
                    songCart: cart.songCart,
                  ),
                )
              ],
            ),
            buildCartUtilLoading(),
          ],
        ),
      ),
    );
  }

  Scaffold buildPageLoading() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          CartAppBar(
            hasPrice: false,
            height: ScreenUtil(context: context).getScreenHeight() * 0.12,
          ),
          Expanded(
            child: Center(
              child: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder buildCartUtilLoading() {
    return BlocBuilder<CartUtilBloc, CartUtilState>(
      builder: (context, state) {
        if (state is CartUtilLoadingState) {
          return Container(
            color: AppColors.white.withOpacity(
              0.5,
            ),
            child: Center(
              child: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Scaffold buildPageEmpty() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          CartAppBar(
            hasPrice: false,
            height: ScreenUtil(context: context).getScreenHeight() * 0.12,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.padding_20),
              child: Column(
                children: [
                  SizedBox(
                    height: AppMargin.margin_58,
                  ),
                  Container(
                    height: AppIconSizes.icon_size_64 * 3,
                    width: AppIconSizes.icon_size_64 * 3,
                    child: Center(
                      child: LottieBuilder.asset(
                        'assets/lottie/cart_empty.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  Text(
                    AppLocale.of().cartIsEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_4,
                  ),
                  Text(
                    AppLocale.of().empityCartCheckOutMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.txtGrey,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  AppBouncingButton(
                    onTap: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                          AppRouterPaths.homeRoute,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_20,
                        vertical: AppPadding.padding_8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.darkOrange,
                      ),
                      child: Text(
                        AppLocale.of().goToHomeScreen,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildPageLoadingError() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          CartAppBar(
            hasPrice: false,
            height: ScreenUtil(context: context).getScreenHeight() * 0.12,
          ),
          Expanded(
            child: AppError(
              bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
              onRetry: () {
                BlocProvider.of<CartPageBloc>(context).add(
                  LoadCartPageEvent(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool cartIsEmpty(CartPageData cartPageData) {
    int total = cartPageData.cart.albumCart.items.length;
    total = total + cartPageData.cart.playlistCart.items.length;
    total = total + cartPageData.cart.songCart.items.length;

    if (total > 0) {
      return false;
    }
    return true;
  }
}
