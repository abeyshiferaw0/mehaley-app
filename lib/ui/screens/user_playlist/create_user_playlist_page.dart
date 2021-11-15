import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/cubits/image_picker_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/widgets/image_picker_dialog_items.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class CreateUserPlaylistPage extends StatefulWidget {
  const CreateUserPlaylistPage(
      {Key? key,
      required this.createWithSong,
      required this.song,
      this.onCreateWithSongSuccess})
      : super(key: key);

  final bool createWithSong;
  final Function(MyPlaylist myPlaylist)? onCreateWithSongSuccess;
  final Song? song;

  @override
  _CreateUserPlaylistPageState createState() => _CreateUserPlaylistPageState();
}

class _CreateUserPlaylistPageState extends State<CreateUserPlaylistPage> {
  ///
  late bool showDescription;
  late int descriptionMaxLength;
  late int nameMaxLength;
  late TextEditingController descriptionInputController;
  late TextEditingController nameInputController;

  ///
  late File selectedImage;

  @override
  void initState() {
    showDescription = false;
    descriptionMaxLength = 200;
    nameMaxLength = 35;
    descriptionInputController = TextEditingController();
    nameInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionInputController.dispose();
    nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPlaylistBloc, UserPlaylistState>(
      listener: (context, state) {
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: AppLocale.of().unableToCreatePlaylist,
              bgColor: AppColors.black,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: PhosphorIcons.wifi_x_light,
            ),
          );
        }

        if (state is UserPlaylistPostedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.white,
              msg: AppLocale.of().playlistCreated(
                playlistName: L10nUtil.translateLocale(
                  state.myPlaylist.playlistNameText,
                  context,
                ),
              ),
              bgColor: AppColors.black,
              isFloating: true,
              iconColor: AppColors.darkOrange,
              icon: PhosphorIcons.check_circle_fill,
            ),
          );
          if (widget.createWithSong) {
            ///POP UNTIL ADD SONG TO PLAYLIST PAGE
            ///GO TO PLAYLIST DETAIL PAGE
            Navigator.pop(context, true);
            if (widget.onCreateWithSongSuccess != null) {
              widget.onCreateWithSongSuccess!(state.myPlaylist);
            }
          } else {
            ///GO TO PLAYLIST DETAIL PAGE
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTopItems(context),
                      SizedBox(
                        height: AppMargin.margin_32,
                      ),
                      buildImageAndPicker(context),
                      SizedBox(
                        height: AppMargin.margin_32,
                      ),
                      buildPlaylistName(),
                      SizedBox(
                        height: AppMargin.margin_32,
                      ),
                      buildPlaylistDescriptionAndButton(),
                      SizedBox(
                        height: AppMargin.margin_62,
                      ),
                      buildPageDescription(),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
              builder: (context, state) {
                if (state is UserPlaylistLoadingState) {
                  return buildPostingPlaylistLoading();
                }
                return SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Container buildPostingPlaylistLoading() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_32,
      ),
      child: AppLoading(
        size: AppValues.loadingWidgetSize * 0.5,
      ),
    );
  }

  Stack buildPlaylistDescriptionAndButton() {
    return Stack(
      children: [
        Visibility(
          visible: showDescription,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            //autofocus: true,
            controller: descriptionInputController,
            cursorColor: AppColors.darkOrange,
            onChanged: (key) {},
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLength: descriptionMaxLength,
            decoration: InputDecoration(
              fillColor: AppColors.black,
              focusColor: AppColors.black,
              hoverColor: AppColors.black,
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.darkOrange),
              ),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocale.of().addSomeDescription,
              hintStyle: TextStyle(
                color: AppColors.txtGrey,
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: AppBouncingButton(
                onTap: () {
                  descriptionInputController.clear();
                  setState(() {
                    showDescription = false;
                  });
                },
                child: Icon(
                  PhosphorIcons.x_light,
                  color: AppColors.darkGrey,
                  size: AppFontSizes.font_size_24,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !showDescription,
          child: AppBouncingButton(
            onTap: () {
              setState(() {
                showDescription = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.padding_6,
                horizontal: AppPadding.padding_20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.darkGrey),
              ),
              child: Text(
                AppLocale.of().addDescripption.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildPageDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_32 * 2,
      ),
      child: Text(
        AppLocale.of().createPlaylistMsg,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.txtGrey,
        ),
      ),
    );
  }

  TextFormField buildPlaylistName() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      //autofocus: true,
      controller: nameInputController,
      cursorColor: AppColors.darkOrange,
      onChanged: (key) {},
      style: TextStyle(
        color: AppColors.black,
        fontSize: AppFontSizes.font_size_18.sp,
        fontWeight: FontWeight.w600,
      ),
      buildCounter: (
        context, {
        required currentLength,
        maxLength,
        required isFocused,
      }) =>
          Text(
        '$currentLength/$maxLength',
        style: TextStyle(
          color: AppColors.darkOrange,
          fontSize: AppFontSizes.font_size_10,
        ),
      ),
      maxLength: nameMaxLength,
      decoration: InputDecoration(
        fillColor: AppColors.black,
        focusColor: AppColors.black,
        hoverColor: AppColors.black,
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkOrange),
        ),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: AppLocale.of().playlistName,
        hintStyle: TextStyle(
          color: AppColors.txtGrey,
          fontSize: AppFontSizes.font_size_18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Builder buildImageAndPicker(BuildContext context) {
    return Builder(
      builder: (context) {
        return AppBouncingButton(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: AppColors.transparent,
              context: context,
              builder: (_) {
                return Wrap(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: AppMargin.margin_16,
                        horizontal: AppMargin.margin_16,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: AppMargin.margin_16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocale.of().chooseImage,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              PagesUtilFunctions.takeAPhoto(
                                context: context,
                                onImageChanged: () {},
                              );
                            },
                            text: AppLocale.of().takeAPhoto,
                            icon: PhosphorIcons.camera_light,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              PagesUtilFunctions.getFromGallery(
                                context: context,
                                onImageChanged: () {},
                              );
                            },
                            text: AppLocale.of().pickFromGallery,
                            icon: PhosphorIcons.image_light,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .removeImage();
                              Navigator.pop(context);
                            },
                            text: AppLocale.of().removeIImage,
                            icon: PhosphorIcons.minus_circle_light,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Column(
            children: [
              AppCard(
                child: BlocBuilder<ImagePickerCubit, File?>(
                  builder: (context, state) {
                    if (state != null) {
                      selectedImage = state;
                      return Image(
                        width: AppValues.createPlaylistImageSize,
                        height: AppValues.createPlaylistImageSize,
                        fit: BoxFit.cover,
                        image: FileImage(selectedImage),
                      );
                    } else {
                      selectedImage = File('');
                      return Container(
                        width: AppValues.createPlaylistImageSize,
                        height: AppValues.createPlaylistImageSize,
                        child: buildImagePlaceHolder(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: AppMargin.margin_12,
              ),
              Text(
                AppLocale.of().changeImage.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildTopItems(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppMargin.margin_16,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppBouncingButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                PhosphorIcons.x_light,
                size: AppIconSizes.icon_size_24,
                color: AppColors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppPadding.padding_6,
              ),
              child: Text(
                AppLocale.of().createPlaylist,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppBouncingButton(
              onTap: () {
                if (nameInputController.text.isNotEmpty) {
                  BlocProvider.of<UserPlaylistBloc>(context).add(
                    PostUserPlaylistEvent(
                      playlistName: nameInputController.text,
                      playlistDescription: descriptionInputController.text,
                      playlistImage: selectedImage,
                      song: widget.song,
                      createWithSong: widget.createWithSong,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildAppSnackBar(
                      txtColor: AppColors.errorRed,
                      msg: AppLocale.of().playlistNameCantBeEmpty,
                      bgColor: AppColors.darkGrey,
                      isFloating: false,
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.padding_4,
                  horizontal: AppPadding.padding_16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: AppColors.darkGrey,
                  ),
                ),
                child: Text(
                  AppLocale.of().save.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
