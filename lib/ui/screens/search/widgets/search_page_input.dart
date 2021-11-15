import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/search_cancel_cubit.dart';
import 'package:mehaley/business_logic/cubits/search_input_is_searching_cubit.dart';
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

  //ANIMATION TRACKER VALUES
  late double padding;

  //DEFAULT VALUES
  final Color barBgColor = AppColors.black.withOpacity(0.2);
  final double barHeight = AppValues.searchBarHeight;
  final double barAnimPadding = 8.0;
  final Color bgDimColor = AppColors.black.withOpacity(0.1);

  @override
  void didChangeDependencies() {
    //SHOW FOCUS FIRST TIME
    setSearching(mIsSearching: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    //INIT ANIMATION TRACKER VALUES
    padding = barAnimPadding;
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight,
      color: bgDimColor,
      child: Center(
        child: AnimatedPadding(
          padding: EdgeInsets.all(padding),
          duration: Duration(milliseconds: 400),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: BlocConsumer<SearchInputIsSearchingCubit, bool>(
              listener: (context, state) {
                setSearching(mIsSearching: state);
              },
              builder: (context, isSearching) {
                if (isSearching) {
                  return buildSearchField();
                } else {
                  return buildSearchButtonTag();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildSearchField() {
    return Container(
      height: barHeight,
      color: barBgColor,
      child: Center(
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: searchTextController,
          // autofocus: true,
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
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocale.of().searchHint,
            hintStyle: TextStyle(
              color: AppColors.darkGrey.withOpacity(0.8),
              fontSize: AppFontSizes.font_size_10.sp,
            ),
            prefixIcon: IconButton(
              color: AppColors.black,
              iconSize: AppIconSizes.icon_size_20,
              icon: Icon(PhosphorIcons.arrow_left_light),
              onPressed: () {
                setSearching(mIsSearching: false);
                searchTextController.clear();
                BlocProvider.of<SearchCancelCubit>(context)
                    .changeSearchingState(cancelSearchingView: true);
              },
            ),
            suffixIcon: IconButton(
              color: AppColors.darkGrey,
              iconSize: AppIconSizes.icon_size_20,
              icon: Icon(PhosphorIcons.x_light),
              onPressed: () {
                searchTextController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildSearchButtonTag() {
    return GestureDetector(
      onTap: () {
        setSearching(mIsSearching: true);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: barBgColor,
          width: double.infinity,
          child: Center(
            child: Text(
              AppLocale.of().search,
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setSearching({required bool mIsSearching}) {
    if (mIsSearching) {
      setState(() {
        padding = 0;
        widget.focusNode.requestFocus();
      });
    } else {
      setState(() {
        padding = barAnimPadding;
      });
    }
    BlocProvider.of<SearchInputIsSearchingCubit>(context)
        .changeIsSearching(mIsSearching);
  }
}
