import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/business_logic/cubits/image_picker_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({Key? key}) : super(key: key);

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  ///
  late int nameMaxLength;
  late TextEditingController nameInputController;

  ///
  late File selectedImage;

  ///
  late bool imageChanged = false;

  late final AppUser appUser;

  @override
  void initState() {
    appUser = BlocProvider.of<AppUserWidgetsCubit>(context).state;
    nameMaxLength = 35;
    nameInputController = TextEditingController();
    initPreviousValues();
    super.initState();
  }

  @override
  void dispose() {
    nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: AppLocale.of().unableToUpdateProfile,
              bgColor: AppColors.white,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: PhosphorIcons.wifi_x_light,
            ),
          );
        }
        if (state is AuthUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.black,
              msg: AppLocale.of().profileUpdated,
              bgColor: AppColors.white,
              isFloating: true,
              iconColor: AppColors.darkGreen,
              icon: PhosphorIcons.check_circle_fill,
            ),
          );
          Navigator.pop(context, state.appUser);
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
                        height: AppMargin.margin_32 * 2,
                      ),
                      buildImageAndPicker(context),
                      SizedBox(
                        height: AppMargin.margin_48,
                      ),
                      buildProfileName(),
                      SizedBox(
                        height: AppMargin.margin_32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthProfileUpdatingState) {
                  return buildEditingProfileLoading();
                }
                return SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Container buildEditingProfileLoading() {
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

  TextFormField buildProfileName() {
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
        '$currentLength/$maxLength',
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
        hintText: AppLocale.of().profileName,
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
                            onTap: () async {
                              PagesUtilFunctions.takeAPhoto(
                                context: context,
                                onImageChanged: () {
                                  imageChanged = true;
                                },
                              );
                            },
                            text: AppLocale.of().trackAPhoto,
                            icon: PhosphorIcons.camera_light,
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
                            icon: PhosphorIcons.image_light,
                          ),
                          ImagePickerDialogItems(
                            onTap: () {
                              imageChanged = true;
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .removeImage();
                              Navigator.pop(context);
                            },
                            text: AppLocale.of().removeImage,
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
                radius: AppValues.editProfileImageSize,
                child: BlocBuilder<ImagePickerCubit, File?>(
                  builder: (context, state) {
                    if (!imageChanged) {
                      selectedImage = File('');

                      ///IMAGE FROM NETWORK
                      if (appUser.profileImageId != null) {
                        return CachedNetworkImage(
                          width: AppValues.editProfileImageSize,
                          height: AppValues.editProfileImageSize,
                          imageUrl: AppApi.baseUrl +
                              appUser.profileImageId!.imageMediumPath,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              buildImagePlaceHolder(),
                          errorWidget: (context, url, error) =>
                              buildImagePlaceHolder(),
                        );
                      } else {
                        return Container(
                          width: AppValues.editProfileImageSize,
                          height: AppValues.editProfileImageSize,
                          child: buildImagePlaceHolder(),
                        );
                      }
                    } else {
                      ///IMAGE FROM DEVICE SELECTED
                      if (state != null) {
                        selectedImage = state;
                        return Image(
                          width: AppValues.editProfileImageSize,
                          height: AppValues.editProfileImageSize,
                          fit: BoxFit.cover,
                          image: FileImage(selectedImage),
                        );
                      } else {
                        selectedImage = File('');
                        return Container(
                          width: AppValues.editProfileImageSize,
                          height: AppValues.editProfileImageSize,
                          child: buildImagePlaceHolder(),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Text(
                AppLocale.of().changeImage.toUpperCase(),
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
                AppLocale.of().editProfile,
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
                  ///EDIT
                  BlocProvider.of<AuthBloc>(context).add(
                    EditUserEvent(
                      userName: nameInputController.text,
                      image: selectedImage,
                      imageChanged: imageChanged,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildAppSnackBar(
                      txtColor: AppColors.errorRed,
                      msg: AppLocale.of().userNameCantBeEmpty,
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
                  AppLocale.of().save.toUpperCase(),
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
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }

  void initPreviousValues() {
    nameInputController.text = AuthUtil.getUserName(
      BlocProvider.of<AppUserWidgetsCubit>(context).state,
    );
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
