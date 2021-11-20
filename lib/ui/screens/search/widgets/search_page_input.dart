import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/search_cancel_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class SearchPageInput extends StatefulWidget {
  SearchPageInput({
    Key? key,
    required this.onSearchQueryChange,
    required this.onSearchEmpty,
    required this.focusNode,
  }) : super(key: key);

  final Function(String) onSearchQueryChange;
  final VoidCallback onSearchEmpty;
  final FocusNode focusNode;

  @override
  _SearchPageInputState createState() => _SearchPageInputState();
}

class _SearchPageInputState extends State<SearchPageInput> {
  String prevKey = '';

  //TEXT CONTROLLER
  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.searchPersistentSliverInputHeaderHeight,
      decoration: BoxDecoration(
        color: AppColors.pagesBgColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            spreadRadius: 1,
            blurRadius: 4,
            color: AppColors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppMargin.margin_16,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 8,
                color: AppColors.black.withOpacity(0.15),
              ),
            ],
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: searchTextController,
            autofocus: true,
            focusNode: widget.focusNode,
            cursorColor: AppColors.darkOrange,
            onChanged: (key) {
              if (key.isEmpty || key == '') {
                widget.onSearchEmpty();
              } else {
                if (key != prevKey) {
                  widget.onSearchQueryChange(key);
                }
              }
              prevKey = key;
            },
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              fillColor: AppColors.black,
              focusColor: AppColors.black,
              hoverColor: AppColors.black,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: AppPadding.padding_16,
              ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocale.of().searchHint,
              hintStyle: TextStyle(
                color: AppColors.darkGrey.withOpacity(0.8),
                fontSize: AppFontSizes.font_size_10.sp,
              ),
              prefixIcon: Icon(
                FlutterRemix.search_line,
                size: AppIconSizes.icon_size_20,
                color: AppColors.black,
              ),
              suffixIcon: IconButton(
                color: AppColors.black,
                iconSize: AppIconSizes.icon_size_20,
                icon: Icon(FlutterRemix.close_line),
                onPressed: () {
                  searchTextController.clear();
                  BlocProvider.of<SearchCancelCubit>(context)
                      .changeSearchingState(
                    cancelSearchingView: true,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
