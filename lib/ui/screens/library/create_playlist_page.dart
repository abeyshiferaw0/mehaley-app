import 'dart:io';

import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/business_logic/cubits/image_picker_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage(
      {Key? key, required this.createWithSong, required this.song})
      : super(key: key);

  final bool createWithSong;
  final Song? song;

  @override
  _CreatePlaylistPageState createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
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
    if (widget.createWithSong) {
      ///POP UNTIL ADD SONG TO PLAYLIST PAGE
      Navigator.of(context).popUntil(
        ModalRoute.withName(AppRouterPaths.songAddToPlaylist),
      );
    }
    return BlocListener<UserPlaylistBloc, UserPlaylistState>(
      listener: (context, state) {
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: "Unable to create playlist\ncheck your internet connection",
              bgColor: AppColors.white,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: PhosphorIcons.wifi_x_light,
            ),
          );
        }

        if (state is UserPlaylistPostedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.black,
              msg:
                  "Playlist ${state.myPlaylist.playlistNameText.textAm} created",
              bgColor: AppColors.white,
              isFloating: true,
              iconColor: AppColors.darkGreen,
              icon: PhosphorIcons.check_circle_fill,
            ),
          );
          if (widget.createWithSong) {
            ///POP UNTIL ADD SONG TO PLAYLIST PAGE
            Navigator.of(context).popUntil(
              ModalRoute.withName(AppRouterPaths.songAddToPlaylist),
            );
          } else {
            ///GO TO PLAYLIST DETAIL PAGE
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
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
        color: AppColors.completelyBlack.withOpacity(0.5),
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
            cursorColor: AppColors.darkGreen,
            onChanged: (key) {},
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLength: descriptionMaxLength,
            decoration: InputDecoration(
              fillColor: AppColors.white,
              focusColor: AppColors.white,
              hoverColor: AppColors.white,
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.darkGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.darkGreen),
              ),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Add some description",
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
                  color: AppColors.lightGrey,
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
                border: Border.all(width: 1, color: AppColors.lightGrey),
              ),
              child: Text(
                "Add Description".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightGrey,
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
        "Create and manage your own customized playlists with elf play",
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
      cursorColor: AppColors.darkGreen,
      onChanged: (key) {},
      style: TextStyle(
        color: AppColors.white,
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
        "$currentLength/$maxLength",
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppFontSizes.font_size_10,
        ),
      ),
      maxLength: nameMaxLength,
      decoration: InputDecoration(
        fillColor: AppColors.white,
        focusColor: AppColors.white,
        hoverColor: AppColors.white,
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.darkGreen),
        ),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: "Playlist Name",
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
                                "Choose Image",
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
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .getFromCamera();
                              Navigator.pop(context);
                            },
                            text: "Tack a Photo",
                            icon: PhosphorIcons.camera_light,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .getFromGallery();
                              Navigator.pop(context);
                            },
                            text: "Pick From Gallery",
                            icon: PhosphorIcons.image_light,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .removeImage();
                              Navigator.pop(context);
                            },
                            text: "Remove Image",
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
                      selectedImage = File("");
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
                "change image".toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
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
                color: AppColors.white,
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
                "Create Playlist",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
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
                      msg: "Playlist name can't be empty",
                      bgColor: AppColors.lightGrey,
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: AppColors.lightGrey,
                  ),
                ),
                child: Text(
                  "Save".toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
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

class ImagePickerDialogItems extends StatelessWidget {
  const ImagePickerDialogItems({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.black,
              size: AppIconSizes.icon_size_24,
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
