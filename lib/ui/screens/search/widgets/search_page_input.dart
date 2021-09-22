import 'package:elf_play/business_logic/cubits/search_cancel_cubit.dart';
import 'package:elf_play/business_logic/cubits/search_input_is_searching_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class SearchPageInput extends StatefulWidget {
  const SearchPageInput(
      {Key? key,
      required this.onSearchQueryChange,
      required this.onSearchEmpty})
      : super(key: key);

  final Function(String) onSearchQueryChange;
  final VoidCallback onSearchEmpty;

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
  final Color barBgColor = AppColors.white.withOpacity(0.2);
  final double barHeight = AppValues.searchBarHeight;
  final double barAnimPadding = 8.0;
  final Color bgDimColor = AppColors.white.withOpacity(0.1);

  ///FOCUS NODE
  FocusNode focusNode = FocusNode();

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
  void di() {
    //AppFocusNode.focusNode.unfocus();
    super.deactivate();
  }

  @override
  void dispose() {
    focusNode.unfocus();
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
          autofocus: true,
          focusNode: focusNode,
          cursorColor: AppColors.darkGreen,
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
            color: AppColors.white,
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            fillColor: AppColors.white,
            focusColor: AppColors.white,
            hoverColor: AppColors.white,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search elf for mezmurs, albums, playlists",
            hintStyle: TextStyle(
              color: AppColors.txtGrey,
              fontSize: AppFontSizes.font_size_10.sp,
            ),
            prefixIcon: IconButton(
              color: AppColors.white,
              iconSize: AppIconSizes.icon_size_20,
              icon: Icon(PhosphorIcons.arrow_left_light),
              onPressed: () {
                print("asdasdasd 2");
                setSearching(mIsSearching: false);
                searchTextController.clear();
                BlocProvider.of<SearchCancelCubit>(context)
                    .changeSearchingState(cancelSearchingView: true);
              },
            ),
            suffixIcon: IconButton(
              color: AppColors.lightGrey,
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
              "Search",
              style: TextStyle(
                color: AppColors.white,
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
        //AppFocusNode.focusNode.requestFocus();
      });
    } else {
      setState(() {
        padding = barAnimPadding;
        //AppFocusNode.focusNode.unfocus();
      });
    }
    BlocProvider.of<SearchInputIsSearchingCubit>(context)
        .changeIsSearching(mIsSearching);
  }
}
