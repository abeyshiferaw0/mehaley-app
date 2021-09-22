import 'dart:io';

import 'package:elf_play/business_logic/cubits/image_picker_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage({Key? key}) : super(key: key);

  @override
  _CreatePlaylistPageState createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                            size: AppIconSizes.icon_size_32,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Create Playlist",
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppBouncingButton(
                          onTap: () {},
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
                ),
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                AppBouncingButton(
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
                                          fontSize:
                                              AppFontSizes.font_size_12.sp,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppBouncingButton(
                                    onTap: () {
                                      BlocProvider.of<ImagePickerCubit>(context)
                                          .getFromCamera();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.padding_16,
                                        vertical: AppPadding.padding_16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            PhosphorIcons.camera_light,
                                            color: AppColors.black,
                                            size: AppIconSizes.icon_size_24,
                                          ),
                                          SizedBox(
                                            width: AppMargin.margin_16,
                                          ),
                                          Text(
                                            "Tack a Photo",
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSizes.font_size_12.sp,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AppBouncingButton(
                                    onTap: () {
                                      BlocProvider.of<ImagePickerCubit>(context)
                                          .getFromGallery();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.padding_16,
                                        vertical: AppPadding.padding_16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            PhosphorIcons.image_light,
                                            color: AppColors.black,
                                            size: AppIconSizes.icon_size_24,
                                          ),
                                          SizedBox(
                                            width: AppMargin.margin_16,
                                          ),
                                          Text(
                                            "Pick From Gallery",
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSizes.font_size_12.sp,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AppBouncingButton(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.padding_16,
                                        vertical: AppPadding.padding_16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            PhosphorIcons.minus_circle_light,
                                            color: AppColors.black,
                                            size: AppIconSizes.icon_size_24,
                                          ),
                                          SizedBox(
                                            width: AppMargin.margin_16,
                                          ),
                                          Text(
                                            "Remove Image",
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSizes.font_size_12.sp,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AppCard(
                    child: BlocBuilder<ImagePickerCubit, XFile?>(
                      builder: (context, state) {
                        if (state != null) {
                          return Image(
                            width: AppValues.createPlaylistImageSize,
                            height: AppValues.createPlaylistImageSize,
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(state.path),
                            ),
                          );
                        } else {
                          return Container(
                            width: AppValues.createPlaylistImageSize,
                            height: AppValues.createPlaylistImageSize,
                            child: buildImagePlaceHolder(),
                          );
                        }
                      },
                    ),
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
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  cursorColor: AppColors.darkGreen,
                  onChanged: (key) {},
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSizes.font_size_18.sp,
                    fontWeight: FontWeight.w600,
                  ),
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
                ),
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                AppBouncingButton(
                  onTap: () {},
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
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_62,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_32,
                  ),
                  child: Text(
                    "Create and manage your own customized playlists",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
