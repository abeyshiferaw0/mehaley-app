import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/cubits/image_picker_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/widgets/image_picker_dialog_items.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class EditUserPlaylistPage extends StatefulWidget {
  const EditUserPlaylistPage({Key? key, required this.myPlaylist})
      : super(key: key);

  final MyPlaylist myPlaylist;

  @override
  _EditUserPlaylistPageState createState() => _EditUserPlaylistPageState();
}

class _EditUserPlaylistPageState extends State<EditUserPlaylistPage> {
  ///
  late bool showDescription;
  late int descriptionMaxLength;
  late int nameMaxLength;
  late TextEditingController descriptionInputController;
  late TextEditingController nameInputController;

  ///
  late File selectedImage;

  ///
  late bool imageChanged = false;

  @override
  void initState() {
    showDescription = false;
    descriptionMaxLength = 200;
    nameMaxLength = 35;
    descriptionInputController = TextEditingController();
    nameInputController = TextEditingController();
    initPreviousValues();
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
              msg: AppLocale.of().unableUpdatePlaylist,
              bgColor: ColorMapper.getWhite(),
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: FlutterRemix.wifi_off_line,
            ),
          );
        }
        if (state is UserPlaylistUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: ColorMapper.getWhite(),
              msg: AppLocale.of().playlistUpdated(
                playlistName: L10nUtil.translateLocale(
                  state.myPlaylist.playlistNameText,
                  context,
                ),
              ),
              bgColor: AppColors.blue,
              isFloating: true,
              iconColor: ColorMapper.getWhite(),
              icon: FlutterRemix.checkbox_circle_fill,
            ),
          );
          Navigator.pop(context, state.myPlaylist);
        }
      },
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
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
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
              builder: (context, state) {
                if (state is UserPlaylistLoadingState) {
                  return buildEditingPlaylistLoading();
                }
                return SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Container buildEditingPlaylistLoading() {
    return Container(
      decoration: BoxDecoration(
        color: ColorMapper.getBlack().withOpacity(0.5),
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
            cursorColor: ColorMapper.getDarkOrange(),
            onChanged: (key) {},
            style: TextStyle(
              color: ColorMapper.getBlack(),
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLength: descriptionMaxLength,
            decoration: InputDecoration(
              fillColor: ColorMapper.getBlack(),
              focusColor: ColorMapper.getBlack(),
              hoverColor: ColorMapper.getBlack(),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorMapper.getLightGrey()),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorMapper.getDarkOrange()),
              ),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocale.of().addSomeDescription,
              hintStyle: TextStyle(
                color: ColorMapper.getTxtGrey(),
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
                  FlutterRemix.close_line,
                  color: ColorMapper.getDarkGrey(),
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
                border: Border.all(width: 1, color: ColorMapper.getDarkGrey()),
              ),
              child: Text(
                AppLocale.of().addDescription.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorMapper.getDarkGrey(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextFormField buildPlaylistName() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      //autofocus: true,
      controller: nameInputController,
      cursorColor: ColorMapper.getDarkOrange(),
      onChanged: (key) {},
      style: TextStyle(
        color: ColorMapper.getBlack(),
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
          color: ColorMapper.getDarkOrange(),
          fontSize: AppFontSizes.font_size_10,
        ),
      ),
      maxLength: nameMaxLength,
      decoration: InputDecoration(
        fillColor: ColorMapper.getBlack(),
        focusColor: ColorMapper.getBlack(),
        hoverColor: ColorMapper.getBlack(),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMapper.getLightGrey()),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMapper.getDarkOrange()),
        ),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: AppLocale.of().playlistName,
        hintStyle: TextStyle(
          color: ColorMapper.getTxtGrey(),
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
                        color: ColorMapper.getWhite(),
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
                                  color: ColorMapper.getBlack(),
                                ),
                              ),
                            ],
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              PagesUtilFunctions.takeAPhoto(
                                context: context,
                                onImageChanged: () {
                                  imageChanged = true;
                                },
                              );
                            },
                            text: AppLocale.of().takeAPhoto,
                            icon: FlutterRemix.camera_line,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              PagesUtilFunctions.getFromGallery(
                                context: context,
                                onImageChanged: () {
                                  imageChanged = true;
                                },
                              );
                            },
                            text: AppLocale.of().pickFromGallery,
                            icon: FlutterRemix.image_line,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              imageChanged = true;
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .removeImage();
                              Navigator.pop(context);
                            },
                            text: AppLocale.of().removeIImage,
                            icon: FlutterRemix.indeterminate_circle_line,
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
                    if (!imageChanged) {
                      selectedImage = File('');

                      ///IMAGE FROM NETWORK
                      if (widget.myPlaylist.playlistImage != null) {
                        return AppCard(
                          radius: 4.0,
                          child: CachedNetworkImage(
                            width: AppValues.createPlaylistImageSize,
                            height: AppValues.createPlaylistImageSize,
                            imageUrl: widget
                                .myPlaylist.playlistImage!.imageMediumPath,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                buildImagePlaceHolder(),
                            errorWidget: (context, url, error) =>
                                buildImagePlaceHolder(),
                          ),
                        );
                      } else {
                        return Container(
                          width: AppValues.createPlaylistImageSize,
                          height: AppValues.createPlaylistImageSize,
                          child: buildImagePlaceHolder(),
                        );
                      }
                    } else {
                      ///IMAGE FROM DEVICE SELECTED
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
                  color: ColorMapper.getBlack(),
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
                FlutterRemix.close_line,
                size: AppIconSizes.icon_size_24,
                color: ColorMapper.getBlack(),
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
                AppLocale.of().editPlaylist,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getBlack(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppBouncingButton(
              onTap: () {
                if (nameInputController.text.isNotEmpty) {
                  ///EDIT
                  BlocProvider.of<UserPlaylistBloc>(context).add(
                    UpdateUserPlaylistEvent(
                      imageRemoved: imageChanged,
                      playlistDescription: descriptionInputController.text,
                      playlistImage: selectedImage,
                      playlistName: nameInputController.text,
                      playlistId: widget.myPlaylist.playlistId,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildAppSnackBar(
                      txtColor: AppColors.errorRed,
                      msg: AppLocale.of().playlistNameCantBeEmpty,
                      bgColor: ColorMapper.getDarkGrey(),
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
                  color: ColorMapper.getBlack(),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: ColorMapper.getDarkGrey(),
                  ),
                ),
                child: Text(
                  AppLocale.of().save.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorMapper.getWhite(),
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

  void initPreviousValues() {
    nameInputController.text =
        L10nUtil.translateLocale(widget.myPlaylist.playlistNameText, context);
    descriptionInputController.text = L10nUtil.translateLocale(
        widget.myPlaylist.playlistDescriptionText, context);
    if (L10nUtil.translateLocale(
            widget.myPlaylist.playlistDescriptionText, context)
        .isNotEmpty) {
      showDescription = true;
    }
  }
}
